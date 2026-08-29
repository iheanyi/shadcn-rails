# frozen_string_literal: true

require "test_helper"

class DummyEditorExampleTest < ActionDispatch::IntegrationTest
  def test_editor_example_renders_outside_registry
    refute Shadcn::Rails::Registry.key?("editor")

    get "/docs/examples/editor"

    assert_response :success
    assert_select "[data-controller='editor']"
    assert_select "[data-action='shadcn--toggle-group:change->editor#marksChanged']"
    assert_select "[data-action='shadcn--toggle-group:change->editor#alignmentChanged']"
    assert_select "textarea[name='editor[body]']"
    assert_select "pre[data-editor-target='params']"
  end
end
