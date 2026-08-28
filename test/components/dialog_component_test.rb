# frozen_string_literal: true

require "test_helper"

class DialogComponentTest < ViewComponent::TestCase
  def test_renders_dialog_container
    render_inline(Shadcn::DialogComponent.new)

    assert_selector "div[data-controller='shadcn--dialog']"
  end

  def test_renders_with_open_value
    render_inline(Shadcn::DialogComponent.new(open: true))

    assert_selector "div[data-shadcn--dialog-open-value='true']"
  end

  def test_renders_with_modal_value
    render_inline(Shadcn::DialogComponent.new(modal: true))

    assert_selector "div[data-shadcn--dialog-modal-value='true']"
  end

  def test_renders_trigger
    render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_trigger { "Open Dialog" }
    end

    assert_selector "div[data-shadcn--dialog-target='trigger']", text: "Open Dialog"
    assert_selector "div[data-action='click->shadcn--dialog#open']"
  end

  def test_renders_body_in_template
    render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_trigger { "Open" }
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Dialog Title" }
        end
      end
    end

    # Content should be in a template tag for portal pattern
    assert_selector "template[data-shadcn--dialog-target='template']", visible: :all
  end

  def test_with_body_renders_without_raising
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |content|
        content.with_title { "Body Slot" }
      end
    end

    assert_includes result.to_html, "Body Slot"
  end

  def test_with_content_alias_renders_without_raising
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_content do |content|
        content.with_title { "Content Alias" }
      end
    end

    assert_includes result.to_html, "Content Alias"
  end

  def test_renders_template_with_content
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body
    end

    # Template elements are not rendered in DOM, so check HTML directly
    html = result.to_html
    assert html.include?("data-shadcn--dialog-target=\"overlay\"")
    assert html.include?("role=\"dialog\"")
    assert html.include?("aria-modal=\"true\"")
  end

  def test_renders_close_button_in_template
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body
    end

    html = result.to_html
    assert html.include?("aria-label=\"Close\"")
    assert html.include?("click->shadcn--dialog#close")
  end

  def test_renders_header_with_title
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "My Title" }
        end
      end
    end

    html = result.to_html
    assert html.include?("<h2")
    assert html.include?("My Title")
  end

  def test_renders_header_with_description
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_description { "My Description" }
        end
      end
    end

    html = result.to_html
    assert html.include?("text-muted-foreground")
    assert html.include?("My Description")
  end

  def test_renders_footer
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_footer { "Footer content" }
      end
    end

    html = result.to_html
    assert html.include?("Footer content")
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::DialogComponent.new(class_name: "my-dialog"))

    assert_selector "div.my-dialog"
  end
end
