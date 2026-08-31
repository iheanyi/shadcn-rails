# frozen_string_literal: true

require "test_helper"
require "cgi"

class DummyDocsRenderingTest < ActionDispatch::IntegrationTest
  def test_hover_card_and_empty_docs_render_without_invented_slot_calls
    {
      "hover-card" => "with_image",
      "empty" => "with_addon"
    }.each do |slug, bogus_method_name|
      get "/docs/components/#{slug}"

      assert_response :success
      refute_includes response.body, bogus_method_name
    end
  end

  def test_switch_docs_render_live_erb_examples_without_preview_leaks
    get "/docs/components/switch"

    assert_response :success
    html = CGI.unescapeHTML(response.body)

    refute_includes html, "SwitchComponentPreview#"
    refute_includes html, "disabled_checked"
    refute_includes html, "settings_panel"
    refute_includes html, "privacy_settings"
    refute_includes html, "interactive_states"

    assert_select "#examples" do |sections|
      examples_html = CGI.unescapeHTML(sections.first.to_s)

      %w[Default Checked Disabled].each do |heading|
        assert_includes examples_html, heading
      end
      assert_includes examples_html, "With Label"
      assert_includes examples_html, "Required"
      assert_includes examples_html, "In a Form"
      assert_includes examples_html, '<%= render Shadcn::SwitchComponent.new(name: "airplane_mode", id: "airplane_mode") { "Airplane mode" } %>'
      assert_includes examples_html, '<%= render Shadcn::SwitchComponent.new(name: "agreement", id: "agreement", required: true) %>'
    end

    assert_select "h2", { text: "API Reference", count: 1 }
    assert_match(/name.*String.*nil.*Input name attribute/m, html)
    assert_match(/checked.*Boolean.*false.*Whether the switch is on/m, html)
    assert_match(/checked.*Boolean.*false.*Current checked state/m, html)
  end

  def test_docs_code_examples_scroll_instead_of_clipping
    get "/docs/components/switch"

    assert_response :success
    assert_select "div.relative.my-4.min-w-0.max-w-full div.code-block.max-w-full"

    layout = Rails.root.join("app/views/layouts/docs.html.erb").read
    assert_includes layout, "max-width: 100%;"
    assert_includes layout, "min-width: max-content;"

    html = CGI.unescapeHTML(response.body)
    refute_includes html, ">Preview<"
    refute_includes html, ">Code<"
  end
end
