# frozen_string_literal: true

# @label Collapsible
# @display bg_color "#ffffff"
class CollapsibleComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic collapsible component (starts closed)
  def default
    render(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_trigger do
        button_html(:ghost, :sm, "Toggle")
      end
      collapsible.with_body do
        tag.div(class: "rounded-md border px-4 py-3 mt-2 text-sm") do
          "This is the collapsible content. Click the button above to show or hide this content."
        end
      end
    end
  end

  # @label Open by Default
  # Collapsible that starts in an open state
  def open_by_default
    render(Shadcn::CollapsibleComponent.new(open: true)) do |collapsible|
      collapsible.with_trigger do
        button_html(:ghost, :sm, "Toggle")
      end
      collapsible.with_body do
        tag.div(class: "rounded-md border px-4 py-3 mt-2 text-sm") do
          "This collapsible starts open. Click the button to collapse it."
        end
      end
    end
  end

  # @label With Icon Button
  # Collapsible with icon button trigger
  def with_icon_button
    render(Shadcn::CollapsibleComponent.new) do |collapsible|
      collapsible.with_trigger do
        button_html(:ghost, :sm) do
          safe_join([
            chevron_icon,
            tag.span("Can I use this in my project?", class: "ml-2")
          ])
        end
      end
      collapsible.with_body do
        tag.div(class: "rounded-md border px-4 py-3 mt-2 text-sm") do
          "Yes! This library is free and open-source. You can use it in your projects."
        end
      end
    end
  end

  # @label FAQ Item
  # Styled as a frequently asked question
  def faq_item
    render(Shadcn::CollapsibleComponent.new(class_name: "w-full space-y-2")) do |collapsible|
      collapsible.with_trigger do
        tag.div(class: "flex items-center justify-between w-full p-4 text-left bg-muted rounded-lg hover:bg-muted/80 cursor-pointer") do
          safe_join([
            tag.h4("What is shadcn-rails?", class: "text-sm font-medium"),
            chevron_icon
          ])
        end
      end
      collapsible.with_body do
        tag.div(class: "px-4 pb-4 text-sm text-muted-foreground") do
          "shadcn-rails is a Ruby port of shadcn/ui for Rails applications. It provides beautifully designed components that you can copy and paste into your apps."
        end
      end
    end
  end

  # @label Multiple Items
  # Multiple collapsible sections
  def multiple_items
    tag.div(class: "space-y-2 w-full max-w-md") do
      safe_join([
        render(Shadcn::CollapsibleComponent.new) do |collapsible|
          collapsible.with_trigger do
            section_trigger("@peduarte starred 3 repositories")
          end
          collapsible.with_body do
            section_content(["@radix-ui/primitives", "@radix-ui/colors", "@stitches/react"])
          end
        end,
        render(Shadcn::CollapsibleComponent.new(open: true)) do |collapsible|
          collapsible.with_trigger do
            section_trigger("@shadcn followed 5 users")
          end
          collapsible.with_body do
            section_content(["@vercel", "@nextjs", "@tailwindcss", "@radix-ui", "@remix-run"])
          end
        end
      ])
    end
  end

  # @label Disabled
  # Collapsible in disabled state
  def disabled
    render(Shadcn::CollapsibleComponent.new(disabled: true)) do |collapsible|
      collapsible.with_trigger do
        button_html(:ghost, :sm, "Toggle (Disabled)", "opacity-50 cursor-not-allowed")
      end
      collapsible.with_body do
        tag.div(class: "rounded-md border px-4 py-3 mt-2 text-sm") do
          "This content cannot be toggled because the collapsible is disabled."
        end
      end
    end
  end

  private

  def button_html(variant, size, text = nil, extra_class = nil, &block)
    classes = [
      "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
      variant == :ghost ? "hover:bg-accent hover:text-accent-foreground" : "",
      size == :sm ? "h-9 px-3" : "h-10 px-4 py-2",
      extra_class
    ].compact.join(" ")

    tag.button(class: classes, type: "button") do
      block_given? ? yield : text
    end
  end

  def chevron_icon
    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m9 18 6-6-6-6"/></svg>'.html_safe
  end

  def section_trigger(text)
    tag.div(class: "flex items-center justify-between space-x-4 p-4 hover:bg-muted/50 rounded-lg cursor-pointer") do
      safe_join([
        tag.h4(text, class: "text-sm font-semibold"),
        chevron_icon
      ])
    end
  end

  def section_content(items)
    tag.div(class: "rounded-md border px-4 py-3 mt-2") do
      tag.div(class: "space-y-2") do
        safe_join(items.map { |item|
          tag.div(class: "text-sm font-mono") { item }
        })
      end
    end
  end
end
