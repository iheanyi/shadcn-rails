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
    "badge_html"
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
