# frozen_string_literal: true

module Shadcn
  # Drawer component for mobile-optimized modal panels
  # Matches shadcn/ui Drawer component (built on Vaul)
  #
  # @example Basic drawer
  #   <%= render Shadcn::DrawerComponent.new do |drawer| %>
  #     <% drawer.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new { "Open Drawer" } %>
  #     <% end %>
  #     <% drawer.with_body do |body| %>
  #       <% body.with_header do |header| %>
  #         <% header.with_title { "Edit Profile" } %>
  #         <% header.with_description { "Make changes to your profile." } %>
  #       <% end %>
  #       <div class="p-4">Content here</div>
  #       <% body.with_footer do %>
  #         <%= render Shadcn::ButtonComponent.new { "Save" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class DrawerComponent < BaseComponent
    renders_one :trigger
    renders_one :body, lambda { |**options|
      DrawerContentComponent.new(**options)
    }

    # @param open [Boolean] Whether drawer starts open
    # @param direction [Symbol] :bottom, :top, :left, or :right
    def initialize(open: false, direction: :bottom, **options)
      super(**options)
      @open = open
      @direction = direction
    end

    private

    def drawer_classes
      class_name
    end

    def drawer_data_attrs
      {
        controller: "shadcn--drawer",
        "shadcn--drawer-open-value": @open.to_s,
        "shadcn--drawer-direction-value": @direction.to_s
      }
    end
  end
end
