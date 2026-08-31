# frozen_string_literal: true

require "test_helper"

class DummyShowcaseRedirectTest < ActionDispatch::IntegrationTest
  def test_showcase_redirects_to_component_docs
    get "/showcase"

    assert_response :moved_permanently
    assert_redirected_to "/docs/components"
  end

  def test_component_docs_index_still_renders
    get "/docs/components"

    assert_response :success
  end
end
