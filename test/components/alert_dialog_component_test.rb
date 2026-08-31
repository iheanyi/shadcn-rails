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
    header_classes = header_tag[/class="([^"]*)"/, 1]
    header_tokens = header_classes.split

    assert_includes header_tokens, "grid"
    assert_includes header_tokens, "gap-1.5"
    refute_includes header_classes, "flex flex-col gap-2"
  end

  def test_title_uses_alert_dialog_v4_typography_classes
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
    assert_includes title_classes, "font-semibold"
    assert_includes title_classes, "sm:group-has-data-[slot=alert-dialog-media]/alert-dialog-content:col-start-2"
    refute_includes title_classes, "leading-none"
  end

  def test_action_and_cancel_use_button_component_classes
    result = render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_footer do |footer|
          footer.with_cancel { "Cancel" }
          footer.with_action { "Continue" }
        end
      end
    end

    html = result.to_html
    action_tag = html[/<button[^>]*data-slot="alert-dialog-action"[^>]*>/m]
    cancel_tag = html[/<button[^>]*data-slot="alert-dialog-cancel"[^>]*>/m]
    action_classes = action_tag[/class="([^"]*)"/, 1].split
    cancel_classes = cancel_tag[/class="([^"]*)"/, 1].split

    assert_includes action_classes, "focus-visible:ring-[3px]"
    assert_includes cancel_classes, "shadow-xs"
    refute_includes action_classes, "focus-visible:ring-1"
    refute_includes action_classes, "shadow-sm"
    refute_includes cancel_classes, "focus-visible:ring-1"
    refute_includes cancel_classes, "shadow-sm"
  end

  def test_content_uses_alert_dialog_group_without_size_variants
    result = render_inline(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_body { "Body content" }
    end

    content_tag = result.to_html[/<div[^>]*data-slot="alert-dialog-content"[^>]*>/m]
    content_classes = content_tag[/class="([^"]*)"/, 1]
    content_tokens = content_classes.split

    assert_includes content_tokens, "group/alert-dialog-content"
    assert_includes content_tokens, "sm:max-w-lg"
    refute_includes content_classes, "data-[size=default]"
    refute_includes content_classes, "data-[size=sm]"
    refute_includes content_tokens, "outline-none"
  end
end
