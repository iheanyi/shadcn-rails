# frozen_string_literal: true

module Shadcn
  module Rails
    # Additional tag helpers for shadcn components
    module TagHelper
      # Create a button component with tag-like syntax
      #
      # @example
      #   shadcn_button "Click me", variant: :primary
      #   shadcn_button variant: :outline do
      #     "Submit"
      #   end
      #
      def shadcn_button(content_or_options = nil, options = {}, &block)
        if block_given?
          options = content_or_options || {}
          content = capture(&block)
        else
          content = content_or_options
        end

        render(Ui::ButtonComponent.new(**options)) { content }
      end

      # Create an input component with tag-like syntax
      #
      # @example
      #   shadcn_input name: "email", type: "email", placeholder: "Enter email"
      #
      def shadcn_input(**options)
        render(Ui::InputComponent.new(**options))
      end

      # Create a badge component with tag-like syntax
      #
      # @example
      #   shadcn_badge "New", variant: :secondary
      #
      def shadcn_badge(content_or_options = nil, options = {}, &block)
        if block_given?
          options = content_or_options || {}
          content = capture(&block)
        else
          content = content_or_options
        end

        render(Ui::BadgeComponent.new(**options)) { content }
      end

      # Create an alert component with tag-like syntax
      #
      # @example
      #   shadcn_alert variant: :destructive do |alert|
      #     alert.with_title { "Error" }
      #     alert.with_description { "Something went wrong" }
      #   end
      #
      def shadcn_alert(options = {}, &block)
        render(Ui::AlertComponent.new(**options), &block)
      end

      # Create a card component with tag-like syntax
      #
      # @example
      #   shadcn_card do |card|
      #     card.with_header do
      #       card.with_title { "Title" }
      #     end
      #     card.with_content { "Content" }
      #   end
      #
      def shadcn_card(options = {}, &block)
        render(Ui::CardComponent.new(**options), &block)
      end

      # Create a spinner component
      #
      # @example
      #   shadcn_spinner size: :lg
      #
      def shadcn_spinner(**options)
        render(Ui::SpinnerComponent.new(**options))
      end

      # Create a skeleton component
      #
      # @example
      #   shadcn_skeleton class_name: "h-4 w-[250px]"
      #
      def shadcn_skeleton(**options)
        render(Ui::SkeletonComponent.new(**options))
      end

      # Create a separator component
      #
      # @example
      #   shadcn_separator orientation: :horizontal
      #
      def shadcn_separator(**options)
        render(Ui::SeparatorComponent.new(**options))
      end

      # Create a progress component
      #
      # @example
      #   shadcn_progress value: 60, max: 100
      #
      def shadcn_progress(**options)
        render(Ui::ProgressComponent.new(**options))
      end

      # Create an avatar component
      #
      # @example
      #   shadcn_avatar size: :lg do |avatar|
      #     avatar.with_image(src: user.avatar_url, alt: user.name)
      #     avatar.with_fallback { user.initials }
      #   end
      #
      def shadcn_avatar(options = {}, &block)
        render(Ui::AvatarComponent.new(**options), &block)
      end
    end
  end
end
