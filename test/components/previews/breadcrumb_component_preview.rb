# frozen_string_literal: true

# @label Breadcrumb
# @display bg_color "#ffffff"
class BreadcrumbComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic breadcrumb navigation
  def default
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/components") { "Components" }
      breadcrumb.with_item(current: true) { "Breadcrumb" }
    end
  end

  # @label Two Levels
  # Simple two-level navigation
  def two_levels
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(current: true) { "Dashboard" }
    end
  end

  # @label Deep Navigation
  # Multi-level breadcrumb navigation
  def deep_navigation
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/products") { "Products" }
      breadcrumb.with_item(href: "/products/electronics") { "Electronics" }
      breadcrumb.with_item(href: "/products/electronics/laptops") { "Laptops" }
      breadcrumb.with_item(current: true) { "MacBook Pro 16-inch" }
    end
  end

  # @label With Icons
  # Breadcrumb items with icons
  def with_icons
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") do
        safe_join([
          home_icon,
          tag.span("Home", class: "ml-2")
        ])
      end
      breadcrumb.with_item(href: "/library") do
        safe_join([
          library_icon,
          tag.span("Library", class: "ml-2")
        ])
      end
      breadcrumb.with_item(current: true) do
        safe_join([
          file_icon,
          tag.span("Document", class: "ml-2")
        ])
      end
    end
  end

  # @label E-commerce Example
  # Breadcrumb for a product page
  def ecommerce_example
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/shop") { "Shop" }
      breadcrumb.with_item(href: "/shop/clothing") { "Clothing" }
      breadcrumb.with_item(href: "/shop/clothing/mens") { "Men's" }
      breadcrumb.with_item(current: true) { "Classic T-Shirt" }
    end
  end

  # @label Blog Example
  # Breadcrumb for a blog post
  def blog_example
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/blog") { "Blog" }
      breadcrumb.with_item(href: "/blog/technology") { "Technology" }
      breadcrumb.with_item(current: true) { "Getting Started with Rails 8" }
    end
  end

  # @label Settings Page
  # Breadcrumb for settings navigation
  def settings_page
    render(Shadcn::BreadcrumbComponent.new) do |breadcrumb|
      breadcrumb.with_item(href: "/dashboard") { "Dashboard" }
      breadcrumb.with_item(href: "/settings") { "Settings" }
      breadcrumb.with_item(current: true) { "Profile" }
    end
  end

  # @label Custom Styling
  # Breadcrumb with custom classes
  def custom_styling
    render(Shadcn::BreadcrumbComponent.new(class_name: "text-lg")) do |breadcrumb|
      breadcrumb.with_item(href: "/") { "Home" }
      breadcrumb.with_item(href: "/docs") { "Documentation" }
      breadcrumb.with_item(current: true) { "Components" }
    end
  end

  private

  def home_icon
    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>'.html_safe
  end

  def library_icon
    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="m16 6 4 14"/><path d="M12 6v14"/><path d="M8 8v12"/><path d="M4 4v16"/></svg>'.html_safe
  end

  def file_icon
    '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/></svg>'.html_safe
  end
end
