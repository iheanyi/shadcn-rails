# frozen_string_literal: true

require "test_helper"

class DummyEditorExampleTest < ActionDispatch::IntegrationTest
  def test_editor_example_renders_outside_registry
    refute Shadcn::Rails::Registry.key?("editor")

    get "/docs/examples/editor"

    assert_response :success
    assert_select "form[data-controller='editor'][action='/docs/examples/editor'][method='post']"
    assert_select "[data-action='shadcn--toggle-group:change->editor#marksChanged']"
    assert_select "[data-action='shadcn--toggle-group:change->editor#alignmentChanged']"
    assert_select "[data-shadcn--toggle-group-target='item'][data-action='click->shadcn--toggle-group#toggle']", 6
    assert_select "[data-shadcn--toggle-group-target='item'][data-action*='editor#']", false
    assert_select "input[type='hidden'][name='editor[marks]'][value='bold']"
    assert_select "input[type='hidden'][name='editor[alignment]'][value='left']"
    assert_select "textarea[name='editor[body]']"
    assert_select "[data-action='click->editor#preview']"
    assert_select "[data-action='click->editor#save']", false
    assert_select "button[type='submit']", text: "Save"
    assert_select "pre[data-editor-target='params']"
  end

  def test_editor_example_shows_posted_params
    post "/docs/examples/editor", params: {
      editor: {
        marks: "bold,underline",
        alignment: "right",
        body: "Ship it"
      }
    }

    assert_response :success
    assert_includes response.body, "params[:editor]"
    assert_includes response.body, '"marks": "bold,underline"'
    assert_includes response.body, '"alignment": "right"'
    assert_includes response.body, '"body": "Ship it"'
  end
end
