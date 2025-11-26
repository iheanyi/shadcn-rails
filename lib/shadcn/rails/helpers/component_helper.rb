# frozen_string_literal: true

module Shadcn
  module Rails
    module Helpers
      # Helper methods for rendering shadcn components
      module ComponentHelper
        extend ActiveSupport::Concern

        # Render a shadcn component by name
        # This allows for cleaner ERB syntax
        #
        # @param name [Symbol, String] Component name (e.g., :button, :card)
        # @param args [Hash] Component arguments
        # @param block [Proc] Optional block for component content
        #
        # @example
        #   <%= shadcn :button, variant: :primary do %>
        #     Click me
        #   <% end %>
        #
        def shadcn(name, **args, &block)
          component_class = Shadcn::Rails.component_for(name)
          render(component_class.new(**args), &block)
        end

        # Shorthand helpers for common components
        # These provide a more Rails-like API

        def shadcn_button(**args, &block)
          render(Shadcn::ButtonComponent.new(**args), &block)
        end

        def shadcn_card(**args, &block)
          render(Shadcn::CardComponent.new(**args), &block)
        end

        def shadcn_input(**args)
          render(Shadcn::InputComponent.new(**args))
        end

        def shadcn_label(**args, &block)
          render(Shadcn::LabelComponent.new(**args), &block)
        end

        def shadcn_badge(**args, &block)
          render(Shadcn::BadgeComponent.new(**args), &block)
        end

        def shadcn_alert(**args, &block)
          render(Shadcn::AlertComponent.new(**args), &block)
        end

        def shadcn_dialog(**args, &block)
          render(Shadcn::DialogComponent.new(**args), &block)
        end
      end
    end
  end
end
