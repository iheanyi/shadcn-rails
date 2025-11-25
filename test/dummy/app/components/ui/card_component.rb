# frozen_string_literal: true

module Ui
  class CardComponent < BaseComponent
    renders_one :header, "HeaderComponent"
    renders_one :title, "TitleComponent"
    renders_one :description, "DescriptionComponent"
    renders_one :card_content, "ContentComponent"
    renders_one :footer, "FooterComponent"

    def initialize(class_name: nil, **html_options)
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(class: card_classes, **@html_options) do
        safe_join([header, title, description, card_content, footer, content].compact)
      end
    end

    private

    def card_classes
      cn(
        # Base classes matching shadcn/ui
        "rounded-xl border bg-card text-card-foreground shadow",
        @class_name
      )
    end

    class HeaderComponent < BaseComponent
      def initialize(class_name: nil, **html_options)
        @class_name = class_name
        @html_options = html_options
      end

      def call
        tag.div(content, class: cn("flex flex-col space-y-1.5 p-6", @class_name), **@html_options)
      end
    end

    class TitleComponent < BaseComponent
      def initialize(class_name: nil, **html_options)
        @class_name = class_name
        @html_options = html_options
      end

      def call
        tag.h3(content, class: cn("font-semibold leading-none tracking-tight", @class_name), **@html_options)
      end
    end

    class DescriptionComponent < BaseComponent
      def initialize(class_name: nil, **html_options)
        @class_name = class_name
        @html_options = html_options
      end

      def call
        tag.p(content, class: cn("text-sm text-muted-foreground", @class_name), **@html_options)
      end
    end

    class ContentComponent < BaseComponent
      def initialize(class_name: nil, **html_options)
        @class_name = class_name
        @html_options = html_options
      end

      def call
        tag.div(content, class: cn("p-6 pt-0", @class_name), **@html_options)
      end
    end

    class FooterComponent < BaseComponent
      def initialize(class_name: nil, **html_options)
        @class_name = class_name
        @html_options = html_options
      end

      def call
        tag.div(content, class: cn("flex items-center p-6 pt-0", @class_name), **@html_options)
      end
    end
  end
end
