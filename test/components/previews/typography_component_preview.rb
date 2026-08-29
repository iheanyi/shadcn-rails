# frozen_string_literal: true

# @label Typography
# @display bg_color "#ffffff"
class TypographyComponentPreview < ViewComponent::Preview
  # @label Default
  # Default typography example
  def default
    h1
  end

  # @label Heading 1
  # Large heading style
  def h1
    render(Shadcn::TypographyComponent.new(variant: :h1)) { "The Joke Tax Chronicles" }
  end

  # @label Heading 2
  # Section heading style
  def h2
    render(Shadcn::TypographyComponent.new(variant: :h2)) { "The People of the Kingdom" }
  end

  # @label Heading 3
  # Subsection heading style
  def h3
    render(Shadcn::TypographyComponent.new(variant: :h3)) { "The Joke Tax" }
  end

  # @label Heading 4
  # Small heading style
  def h4
    render(Shadcn::TypographyComponent.new(variant: :h4)) { "People stopped telling jokes" }
  end

  # @label Paragraph
  # Default paragraph style
  def paragraph
    render(Shadcn::TypographyComponent.new(variant: :p)) do
      "The king, seeing how much happier his subjects were, realized the error of his ways and repealed the joke tax."
    end
  end

  # @label Lead
  # Lead paragraph for introductions
  def lead
    render(Shadcn::TypographyComponent.new(variant: :lead)) do
      "A modal dialog that interrupts the user with important content and expects a response."
    end
  end

  # @label Large
  # Large text style
  def large
    render(Shadcn::TypographyComponent.new(variant: :large)) { "Are you absolutely sure?" }
  end

  # @label Small
  # Small text style
  def small
    render(Shadcn::TypographyComponent.new(variant: :small)) { "Email address" }
  end

  # @label Muted
  # Muted text for secondary information
  def muted
    render(Shadcn::TypographyComponent.new(variant: :muted)) { "Enter your email address." }
  end

  # @label Blockquote
  # Blockquote style
  def blockquote
    render(Shadcn::TypographyComponent.new(variant: :blockquote)) do
      "After all, everyone enjoys a good laugh, and the people of the kingdom were no exception."
    end
  end

  # @label Inline Code
  # Inline code style
  def code
    render(Shadcn::TypographyComponent.new(variant: :code)) { "@radix-ui/react-alert-dialog" }
  end

  # @label All Variants
  # Overview of all typography variants
  # @param variant select { choices: [h1, h2, h3, h4, p, lead, large, small, muted, blockquote, code, list] }
  def variants(variant: :p)
    render(Shadcn::TypographyComponent.new(variant: variant.to_sym)) { "Sample text for #{variant}" }
  end

  # @label Demo Page
  # Full typography demonstration
  def demo
    render(Shadcn::TypographyComponent.new(variant: :p)) do
      "Typography examples cover headings, paragraphs, lists, quotes, and inline code styles."
    end
  end
end
