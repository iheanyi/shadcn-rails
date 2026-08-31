# frozen_string_literal: true

require "test_helper"
require "cgi"

class DummyDocsCatalogTest < ActionDispatch::IntegrationTest
  PLACEHOLDER = "This example now renders from the component preview source shown by the showcase block on this page."
  FORBIDDEN_CODE_EXAMPLE_PATTERNS = [
    "button_html",
    "omitted for brevity",
    "def default",
    "variant.to_sym",
    "variant.to_s",
    "with_image",
    "with_addon",
    "bold_icon",
    "italic_icon",
    "underline_icon",
    "strikethrough_icon",
    "align_left_icon",
    "align_center_icon",
    "align_right_icon",
    "fallback_table",
    "demo_button",
    "icon_svg",
    "badge_html",
    "PreviewPagy",
    "PreviewCollection",
    "section_trigger",
    "section_content"
  ].freeze
  REQUIRED_PASTEABLE_CODE_EXAMPLES = %w[
    carousel/default
    carousel/usage
    carousel/with-card-content
    empty/background-gradient
    label/disabled_context
    radio-group/horizontal-layout
    select/preselected-value
    select/form-integration
    select/long_list
    table/striped
    scroll-area/usage
    scroll-area/code_block
    chart/default
    chart/area
    chart/line
    chart/pie
    chart/donut
  ].freeze
  BARE_RUBY_LOOP_PATTERN = /(\b\d+\.times|\.each(?:_with_index)?|\)\.each)\s+do\b/

  def test_docs_pages_do_not_contain_placeholder_copy
    docs_views.each do |view|
      refute_includes File.read(view), PLACEHOLDER, "Remove placeholder copy from #{view.basename}"
    end
  end

  def test_code_examples_do_not_leak_lookbook_preview_internals
    code_example_files.each do |example|
      code = File.read(example)

      FORBIDDEN_CODE_EXAMPLE_PATTERNS.each do |pattern|
        refute_includes code, pattern, "#{example.relative_path_from(Rails.root)} should be copy-pasteable ERB"
      end
    end
  end

  def test_code_examples_do_not_contain_bare_ruby_loops
    code_example_files.each do |example|
      File.readlines(example).each_with_index do |line, index|
        next unless line.match?(BARE_RUBY_LOOP_PATTERN)

        assert_includes line, "<%", "#{example.relative_path_from(Rails.root)}:#{index + 1} should wrap Ruby loops in ERB tags"
      end
    end
  end

  def test_code_examples_are_balanced_erb
    code_example_files.each do |example|
      assert_code_example_compiles(example)
    end
  end

  def test_each_docs_showcase_call_has_file_backed_snippet
    showcase_calls.each do |view, slug, example|
      assert code_example_path_for(slug, example),
        "#{view.basename} showcase(\"#{slug}\", :#{example}) should have a matching app/code_examples/#{slug}/#{example}.txt file"
    end
  end

  def test_showcase_helper_does_not_fall_back_to_preview_source
    source = File.read(Rails.root.join("app/helpers/showcase_helper.rb"))

    refute_includes source, "erb_preview_method_source"
    refute_includes source, "preview_method_source"
    assert_includes source, "Missing code example"
  end

  def test_no_go_code_examples_are_explicitly_pasteable_erb
    REQUIRED_PASTEABLE_CODE_EXAMPLES.each do |example_path|
      example = Rails.root.join("app/code_examples/#{example_path}.txt")

      assert_predicate example, :exist?, "#{example_path}.txt should exist"
      assert_code_example_compiles(example)
    end
  end

  def test_stimulus_docs_partial_uses_controller_name_local
    docs_views.each do |view|
      source = File.read(view)
      next unless source.include?('render "docs/stimulus_docs"')

      stimulus_docs_calls(source).each do |call_source|
        refute_match(/\bcontroller:/, call_source, "#{view.basename} should pass controller_name: to docs/stimulus_docs")
      end
    end
  end

  def test_checkbox_docs_do_not_claim_unsupported_javascript_or_indeterminate_api
    sources = [
      Rails.root.join("app/views/docs/checkbox.html.erb"),
      Rails.root.join("app/controllers/docs_controller.rb"),
      Rails.root.join("app/views/layouts/app.html.erb"),
      Rails.root.join("app/views/layouts/application.html.erb"),
      Rails.root.join("app/code_examples/checkbox/usage.txt"),
      *Rails.root.join("app/code_examples/checkbox").glob("*.txt"),
      Rails.root.join("../../test/components/previews/checkbox_component_preview.rb").expand_path
    ]

    sources.each do |path|
      source = File.read(path)

      refute_includes source, "shadcn--checkbox", "#{path.relative_path_from(Rails.root)} should not document a checkbox Stimulus controller"
      refute_includes source, "indeterminate", "#{path.relative_path_from(Rails.root)} should not document unsupported checkbox indeterminate API"
    end
  end

  def test_chart_docs_show_file_backed_erb_for_each_chart_type
    get "/docs/components/chart"

    assert_response :success
    html = CGI.unescapeHTML(response.body)

    %w[line area pie donut].each do |chart_type|
      assert_includes html, "type: :#{chart_type}", "Chart docs should show pasteable ERB for #{chart_type}"
    end

    assert_operator html.scan("<%= render Shadcn::Chart.new").size, :>=, 4
    refute_includes html, "render Shadcn::ChartComponent.new(", "Chart docs should not expose Lookbook Ruby snippets"
  end

  def test_usage_snippets_do_not_show_preview_method_wrappers
    editable_component_slugs.each do |slug|
      get "/docs/components/#{slug}"

      assert_response :success, "Expected #{slug} docs to render"
      assert_select "#usage" do |sections|
        usage_html = CGI.unescapeHTML(sections.first.to_s)

        refute_includes usage_html, "def default", "Usage snippet for #{slug} should be ERB, not Lookbook Ruby"
        refute_includes usage_html, PLACEHOLDER, "Usage snippet for #{slug} should not use placeholder copy"
      end
    end
  end

  private

  def docs_views
    Rails.root.join("app/views/docs").glob("*.html.erb").reject { |view| view.basename.to_s.start_with?("_") }
  end

  def code_example_files
    Rails.root.join("app/code_examples").glob("**/*.txt")
  end

  def showcase_calls
    docs_views.flat_map do |view|
      source = File.read(view)
      explicit_examples = source.scan(/showcase\(["']([^"']+)["']\s*,\s*:([a-zA-Z0-9_]+)/).map do |slug, example|
        [view, slug, example]
      end
      default_examples = source.scan(/showcase\(["']([^"']+)["']\)/).map do |slug|
        [view, slug.first, "default"]
      end

      explicit_examples + default_examples
    end
  end

  def code_example_path_for(slug, example)
    [
      Rails.root.join("app/code_examples/#{slug}/#{example}.txt"),
      Rails.root.join("app/code_examples/#{slug}/#{example.tr('_', '-')}.txt")
    ].find { |path| File.exist?(path) }
  end

  def assert_code_example_compiles(example)
    code = File.read(example)
    source = ActionView::Template::Handlers::ERB.erb_implementation.new(code, escape: false).src

    RubyVM::InstructionSequence.compile(source)
    assert true, "#{example.relative_path_from(Rails.root)} compiles as ERB"
  rescue SyntaxError => error
    flunk "#{example.relative_path_from(Rails.root)} should compile as ERB: #{error.message.lines.first}"
  end

  def stimulus_docs_calls(source)
    source
      .lines
      .slice_before { |line| line.include?('render "docs/stimulus_docs"') }
      .filter_map do |lines|
        next unless lines.first&.include?('render "docs/stimulus_docs"')

        lines.take_while.with_index { |line, index| index.zero? || !line.include?("%>") }.join
      end
  end

  def editable_component_slugs
    DocsController::COMPONENTS.keys
  end
end
