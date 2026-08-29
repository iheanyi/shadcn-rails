# frozen_string_literal: true

# @label Empty
# @display bg_color "#ffffff"
class EmptyComponentPreview < ViewComponent::Preview
  # @label Default
  # Empty state with icon, title, description, and action
  def default
    render(Shadcn::EmptyComponent.new(class_name: "w-full rounded-lg border border-dashed")) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :icon) do
          icon_svg("M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4", "M7 10l5 5 5-5", "M12 15V3")
        end
        header.with_title { "No documents found" }
        header.with_description { "Upload a document to get started." }
      end
      empty.with_content do
        button_html("Upload document")
      end
    end
  end

  private

  def button_html(text)
    %(<button type="button" class="inline-flex h-9 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-xs hover:bg-primary/90">#{text}</button>).html_safe
  end

  def icon_svg(*paths)
    path_tags = paths.map { |path| %(<path d="#{path}"></path>) }.join
    %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">#{path_tags}</svg>).html_safe
  end
end
