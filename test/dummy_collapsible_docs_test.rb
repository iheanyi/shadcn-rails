# frozen_string_literal: true

require "test_helper"

class DummyCollapsibleDocsTest < ActionDispatch::IntegrationTest
  def test_collapsible_docs_render_correct_component_contract
    get "/docs/components/collapsible"

    assert_response :success
    refute_includes response.body, "This example now renders from the component preview source shown by the showcase block on this page."

    assert_select "[data-shadcn--collapsible-target='trigger'][aria-expanded]"
    assert_select "[data-shadcn--collapsible-target='trigger'] button", false
    assert_select "code", text: "shadcn--collapsible"

    headings = css_select("h2").map { |heading| heading.text.squish }
    assert_equal 1, headings.count("API Reference")

    usage_code = css_select("#usage code").map(&:text).join("\n")
    assert_includes usage_code, "Shadcn::Collapsible.new"
    refute_includes usage_code, "Shadcn::CollapsibleComponent.new"
    refute_includes usage_code, "Shadcn::ButtonComponent"

    stimulus_section = css_select("#stimulus").first.to_s
    assert_includes stimulus_section, "shadcn--collapsible"
    refute_includes stimulus_section, ">docs<"
  end
end
