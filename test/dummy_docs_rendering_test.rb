# frozen_string_literal: true

require "test_helper"

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
end
