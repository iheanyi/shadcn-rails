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

    def call
      content_tag(:div, drawer_content, drawer_attributes)
    end

    private

    def drawer_content
      safe_join([
        trigger_wrapper,
        body
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--drawer-target": "trigger",
        "data-action": "click->shadcn--drawer#open"
      })
    end

    def drawer_attributes
      attrs = {
        class: class_name,
        "data-controller": "shadcn--drawer",
        "data-shadcn--drawer-open-value": @open.to_s,
        "data-shadcn--drawer-direction-value": @direction.to_s
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
