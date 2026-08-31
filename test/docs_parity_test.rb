# frozen_string_literal: true

require "test_helper"

Dir[Rails.root.join("../../test/components/previews/**/*_preview.rb")].sort.each { |file| require file }

class DocsParityTest < ViewComponent::TestCase
  include ShowcaseHelper

  def test_each_registry_component_has_docs_controller_entry_docs_page_preview_and_controller_tests
    Shadcn::Rails::Registry.keys.each do |key|
      slug = key.tr("_", "-")
      unit = Shadcn::Rails::Registry.fetch(key)
      docs_page = Rails.root.join("app/views/docs/#{slug}.html.erb")
      preview_class = preview_class_for(key)

      assert DocsController::COMPONENTS.key?(slug), "Expected DocsController::COMPONENTS to include #{slug}"
      assert File.exist?(docs_page), "Expected docs page for #{slug}"
      assert_includes File.read(docs_page), "showcase(\"#{slug}\"", "Expected docs page for #{slug} to render showcase(\"#{slug}\")"
      assert preview_class.present?, "Expected preview class #{preview_class_name_for(key)}"
      assert_includes preview_class.public_instance_methods(false), :default, "Expected #{preview_class.name} to define #default"

      unit.controllers.each do |controller_path|
        test_name = "#{File.basename(controller_path, ".js")}.test.js"
        assert File.exist?(Rails.root.join("../../__tests__/controllers/#{test_name}")),
          "Expected Jest smoke or behavior test for #{controller_path}"
      end
    end
  end

  def test_component_preview_layout_links_compiled_tailwind_stylesheet
    layout = File.read(Rails.root.join("app/views/layouts/component_preview.html.erb"))

    assert_compiled_tailwind_and_components_css(layout)
    assert_includes layout, 'javascript_include_tag "application"'
    assert_includes layout, "shadcn_theme"
  end

  def test_docs_layout_links_compiled_tailwind_stylesheet
    layout = File.read(Rails.root.join("app/views/layouts/docs.html.erb"))

    assert_compiled_tailwind_and_components_css(layout)
    assert_includes layout, 'javascript_include_tag "application"'
    assert_includes layout, "shadcn_theme"
    refute_includes layout, "tailwind.config"
    assert_includes layout, "@keyframes caret-blink"
    assert_includes layout, ".animate-caret-blink"
  end

  def test_dummy_app_layouts_link_compiled_tailwind_stylesheet
    %w[application.html.erb].each do |layout_name|
      layout = File.read(Rails.root.join("app/views/layouts/#{layout_name}"))

      assert_compiled_tailwind_and_components_css(layout)
      refute_includes layout, "tailwind.config"
    end

    app_layout = File.read(Rails.root.join("app/views/layouts/app.html.erb"))

    assert_includes app_layout, 'stylesheet_link_tag "tailwind"'
    assert_includes app_layout, 'stylesheet_link_tag "shadcn/components"'
    assert_includes app_layout, 'javascript_include_tag "application", "data-turbo-track": "reload", type: "module"'
    assert_includes app_layout, "shadcn_theme"
    refute_includes app_layout, "cdn.tailwindcss.com"
    refute_includes app_layout, "unpkg.com/@hotwired/stimulus"
    refute_includes app_layout, "tailwind.config"
    refute_includes app_layout, 'File.read(Shadcn::Rails::Registry.gem_path("app/assets/stylesheets/shadcn/components.css")).html_safe'
  end

  def test_docs_controller_entries_match_registry_keys
    registry_slugs = Shadcn::Rails::Registry.keys.map { |key| key.tr("_", "-") }.sort
    docs_slugs = DocsController::COMPONENTS.keys.sort

    assert_equal registry_slugs, docs_slugs
  end

  def test_all_preview_examples_render
    ViewComponent::Preview.all.each do |preview_class|
      preview_examples_for(preview_class).each do |example|
        content = render_preview_example(preview_class, example)

        assert content.present?, "Expected #{preview_class.name}##{example} to render content"
      rescue StandardError => error
        flunk "Expected #{preview_class.name}##{example} to render, got #{error.class}: #{error.message}\n#{error.backtrace&.first(5)&.join("\n")}"
      end
    end
  end

  private

  def assert_compiled_tailwind_and_components_css(layout)
    assert_includes layout, 'stylesheet_link_tag "tailwind"'
    assert_includes layout, 'File.read(Shadcn::Rails::Registry.gem_path("app/assets/stylesheets/shadcn/components.css")).html_safe'
    refute_includes layout, "cdn.tailwindcss.com"
  end

  def preview_class_for(key)
    preview_class_name_for(key).safe_constantize
  end

  def preview_class_name_for(key)
    "#{key.camelize}ComponentPreview"
  end

  def preview_examples_for(preview_class)
    preview_class.public_instance_methods(false).filter do |method_name|
      preview_method = preview_class.instance_method(method_name)
      preview_method.parameters.none? { |type, _name| type == :req || type == :keyreq }
    end.sort
  end

  def render_preview_example(preview_class, example)
    preview_result = preview_class.new.public_send(example)
    return preview_result if preview_result.is_a?(String)

    if preview_result.is_a?(Hash) && preview_result[:component]
      component = preview_result[:component]
      args = preview_result.fetch(:args, {})
      block = preview_result[:block]
      render_inline(component, **args, &block)
      return rendered_content
    end

    render_inline(preview_result)
    rendered_content
  end
end
