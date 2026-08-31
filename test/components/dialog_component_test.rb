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

  def test_dialog_overlay_uses_v4_background_opacity
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body
    end

    overlay_tag = result.to_html[/<[^>]*data-slot="dialog-overlay"[^>]*>/m]
    overlay_classes = overlay_tag[/class="([^"]*)"/, 1].split
    assert_includes overlay_classes, "bg-black/50"
    refute_includes overlay_classes, "bg-black/80"
  end

  def test_dialog_content_uses_v4_zoom_without_center_slide_classes
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body
    end

    content_tag = result.to_html[/<[^>]*data-slot="dialog-content"[^>]*>/m]
    content_classes = content_tag[/class="([^"]*)"/, 1].split
    assert_includes content_classes, "max-w-[calc(100%-2rem)]"
    assert_includes content_classes, "rounded-lg"
    assert_includes content_classes, "sm:max-w-lg"
    assert_includes content_classes, "outline-none"
    assert_includes content_classes, "data-[state=closed]:zoom-out-95"
    assert_includes content_classes, "data-[state=open]:zoom-in-95"
    refute_includes content_classes, "data-[state=closed]:slide-out-to-left-1/2"
    refute_includes content_classes, "data-[state=closed]:slide-out-to-top-[48%]"
    refute_includes content_classes, "data-[state=open]:slide-in-from-left-1/2"
    refute_includes content_classes, "data-[state=open]:slide-in-from-top-[48%]"
  end

  def test_renders_close_button_in_template
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body
    end

    html = result.to_html
    assert html.include?("aria-label=\"Close\"")
    assert html.include?("click->shadcn--dialog#close")

    close_button_match = html.match(/<button.*?aria-label="Close".*?>/m)
    assert close_button_match

    close_classes = close_button_match[0][/class="([^"]*)"/, 1].split
    assert_includes close_classes, "rounded-xs"
    assert_includes close_classes, "ring-offset-background"
    assert_includes close_classes, "hover:opacity-100"
    assert_includes close_classes, "focus:ring-2"
    assert_includes close_classes, "focus:ring-ring"
    assert_includes close_classes, "focus:ring-offset-2"
    assert_includes close_classes, "focus:outline-hidden"
    assert_includes close_classes, "data-[state=open]:bg-accent"
    assert_includes close_classes, "data-[state=open]:text-muted-foreground"
    assert_includes close_classes, "[&_svg]:pointer-events-none"
    assert_includes close_classes, "[&_svg]:shrink-0"
    assert_includes close_classes, "[&_svg:not([class*='size-'])]:size-4"
    refute_includes close_classes, "focus-visible:ring-2"
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

  def test_header_uses_v4_gap_classes
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_header { "Header content" }
      end
    end

    header_tag = result.to_html[/<[^>]*data-slot="dialog-header"[^>]*>/m]
    header_classes = header_tag[/class="([^"]*)"/, 1].split
    assert_includes header_classes, "gap-2"
    refute_includes header_classes, "space-y-1.5"
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

  def test_footer_uses_v4_gap_classes
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_footer { "Footer content" }
      end
    end

    footer_tag = result.to_html[/<[^>]*data-slot="dialog-footer"[^>]*>/m]
    footer_classes = footer_tag[/class="([^"]*)"/, 1].split
    assert_includes footer_classes, "gap-2"
    refute_includes footer_classes, "sm:space-x-2"
  end

  def test_title_uses_v4_typography_classes
    result = render_inline(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_body do |body|
        body.with_title { "Dialog Title" }
      end
    end

    title_tag = result.to_html[/<[^>]*data-slot="dialog-title"[^>]*>/m]
    title_classes = title_tag[/class="([^"]*)"/, 1].split
    assert_includes title_classes, "text-lg"
    assert_includes title_classes, "leading-none"
    assert_includes title_classes, "font-semibold"
    refute_includes title_classes, "tracking-tight"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::DialogComponent.new(class_name: "my-dialog"))

    assert_selector "div.my-dialog"
  end
end
