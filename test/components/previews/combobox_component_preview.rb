# frozen_string_literal: true

# @label Combobox
# @display bg_color "#ffffff"
class ComboboxComponentPreview < ViewComponent::Preview
  # @label Default
  # Searchable select with framework options
  def default
    render(Shadcn::ComboboxComponent.new(
      items: [
        { value: "rails", label: "Ruby on Rails" },
        { value: "stimulus", label: "Stimulus" },
        { value: "turbo", label: "Turbo" }
      ],
      placeholder: "Select framework...",
      search_placeholder: "Search frameworks..."
    ))
  end
end
