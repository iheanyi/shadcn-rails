# frozen_string_literal: true

module ApplicationHelper
  def component_description(component)
    descriptions = {
      "button" => "Interactive button with variants and sizes",
      "card" => "Container with header, content, and footer",
      "input" => "Text input field with styling",
      "textarea" => "Multi-line text input",
      "select" => "Dropdown select input",
      "checkbox" => "Checkbox input with custom styling",
      "switch" => "Toggle switch input",
      "label" => "Form label with required indicator",
      "badge" => "Small status indicator",
      "alert" => "Attention-grabbing message",
      "dialog" => "Modal dialog window",
      "dropdown_menu" => "Dropdown menu with items",
      "avatar" => "User avatar with fallback",
      "tabs" => "Tabbed content navigation",
      "tooltip" => "Hover tooltip",
      "separator" => "Horizontal or vertical line",
      "skeleton" => "Loading placeholder",
      "spinner" => "Loading indicator",
      "progress" => "Progress bar"
    }
    descriptions[component] || "UI component"
  end

  def component_usage(component)
    usages = {
      "button" => <<~ERB,
        <%%= render Ui::ButtonComponent.new(variant: :default) do %>
          Click me
        <%% end %>

        <%%= render Ui::ButtonComponent.new(variant: :destructive) do %>
          Delete
        <%% end %>

        <%%= render Ui::ButtonComponent.new(variant: :outline, size: :sm) do %>
          Small Outline
        <%% end %>
      ERB
      "card" => <<~ERB,
        <%%= render Ui::CardComponent.new do |card| %>
          <%% card.with_header do %>
            <%% card.with_title { "Card Title" } %>
            <%% card.with_description { "Card description" } %>
          <%% end %>
          <%% card.with_content do %>
            Card content goes here.
          <%% end %>
          <%% card.with_footer do %>
            <button>Action</button>
          <%% end %>
        <%% end %>
      ERB
      "input" => <<~ERB,
        <%%= render Ui::InputComponent.new(
          type: "email",
          name: "email",
          placeholder: "Enter your email"
        ) %>
      ERB
      "badge" => <<~ERB,
        <%%= render Ui::BadgeComponent.new(variant: :default) { "Default" } %>
        <%%= render Ui::BadgeComponent.new(variant: :secondary) { "Secondary" } %>
        <%%= render Ui::BadgeComponent.new(variant: :destructive) { "Destructive" } %>
      ERB
      "alert" => <<~ERB,
        <%%= render Ui::AlertComponent.new(variant: :default) do |alert| %>
          <%% alert.with_title { "Heads up!" } %>
          <%% alert.with_description { "This is an alert message." } %>
        <%% end %>
      ERB
      "spinner" => <<~ERB,
        <%%= render Ui::SpinnerComponent.new(size: :sm) %>
        <%%= render Ui::SpinnerComponent.new(size: :default) %>
        <%%= render Ui::SpinnerComponent.new(size: :lg) %>
      ERB
      "skeleton" => <<~ERB,
        <%%= render Ui::SkeletonComponent.new(class_name: "h-4 w-[250px]") %>
        <%%= render Ui::SkeletonComponent.new(class_name: "h-4 w-[200px]") %>
      ERB
      "progress" => <<~ERB,
        <%%= render Ui::ProgressComponent.new(value: 33) %>
        <%%= render Ui::ProgressComponent.new(value: 66) %>
      ERB
    }
    usages[component] || "<%%= render Ui::#{component.camelize}Component.new %>"
  end
end
