# frozen_string_literal: true

# @label Resizable
# @display bg_color "#ffffff"
class ResizableComponentPreview < ViewComponent::Preview
  # @label Default
  # Two resizable horizontal panels
  def default
    render(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal, class_name: "h-[200px] w-[420px] rounded-lg border")) do |group|
      group.with_panel(default_size: 50) do
        '<div class="flex h-full items-center justify-center p-6 text-sm font-medium">One</div>'.html_safe
      end
      group.with_handle(with_handle: true)
      group.with_panel(default_size: 50) do
        '<div class="flex h-full items-center justify-center p-6 text-sm font-medium">Two</div>'.html_safe
      end
    end
  end
end
