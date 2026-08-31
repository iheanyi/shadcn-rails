# frozen_string_literal: true

require "test_helper"

class AlertDialogComponentTest < ViewComponent::TestCase
  def test_renders_alert_dialog_container
    render_inline(Shadcn::AlertDialogComponent.new)

    assert_selector "div[data-controller='shadcn--dialog']"
  end

  def test_renders_with_trigger
    render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_trigger { "Delete" }
    end

    assert_selector "[data-shadcn--dialog-target='trigger']", text: "Delete"
  end

  def test_renders_body_with_alertdialog_role
    render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Are you sure?" }
        end
      end
    end

    assert_selector "template[data-shadcn--dialog-target='template']", visible: :all
  end

  def test_renders_header_with_title_and_description
    render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Confirm Delete" }
          header.with_description { "This action cannot be undone." }
        end
      end
    end

    assert_selector "template", visible: :all
  end

  def test_renders_footer_with_cancel_and_action
    render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_footer do |footer|
          footer.with_cancel { "Cancel" }
          footer.with_action { "Continue" }
        end
      end
    end

    assert_selector "template", visible: :all
  end

  def test_renders_with_open_state
    render_inline(Shadcn::AlertDialogComponent.new(open: true))

    assert_selector "[data-shadcn--dialog-open-value='true']"
  end

  def test_renders_as_modal
    render_inline(Shadcn::AlertDialogComponent.new)

    assert_selector "[data-shadcn--dialog-modal-value='true']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::AlertDialogComponent.new(class_name: "my-alert-dialog"))

    assert_selector "div.my-alert-dialog"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::AlertDialogComponent.new(class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::AlertDialogComponent.new(data: { testid: "alert-dialog" }))

    assert_selector "[data-testid='alert-dialog']"
  end

  def test_header_uses_v4_gap_classes
    result = render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header { "Header content" }
      end
    end

    header_tag = result.to_html[/<[^>]*data-slot="alert-dialog-header"[^>]*>/m]
    header_classes = header_tag[/class="([^"]*)"/, 1].split

    assert_includes header_classes, "gap-2"
    refute_includes header_classes, "space-y-2"
  end

  def test_title_uses_dialog_v4_typography_classes
    result = render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Alert Dialog Title" }
        end
      end
    end

    title_tag = result.to_html[/<[^>]*data-slot="alert-dialog-title"[^>]*>/m]
    title_classes = title_tag[/class="([^"]*)"/, 1].split

    assert_includes title_classes, "text-lg"
    assert_includes title_classes, "leading-none"
    assert_includes title_classes, "font-semibold"
  end
end
