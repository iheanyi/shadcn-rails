# frozen_string_literal: true

require "test_helper"
require "cgi"

class DummyDocsCatalogTest < ActionDispatch::IntegrationTest
  PLACEHOLDER = "This example now renders from the component preview source shown by the showcase block on this page."

  def test_docs_pages_do_not_contain_placeholder_copy
    docs_views.each do |view|
      refute_includes File.read(view), PLACEHOLDER, "Remove placeholder copy from #{view.basename}"
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

  def editable_component_slugs
    DocsController::COMPONENTS.keys
  end
end
