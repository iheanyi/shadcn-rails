# frozen_string_literal: true

# @label Select
# @display bg_color "#ffffff"
class SelectComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic select with simple options
  def default
    render(Shadcn::SelectComponent.new(name: "fruit", placeholder: "Select a fruit")) do |select|
      select.with_item(value: "apple") { "Apple" }
      select.with_item(value: "banana") { "Banana" }
      select.with_item(value: "orange") { "Orange" }
      select.with_item(value: "grape") { "Grape" }
      select.with_item(value: "strawberry") { "Strawberry" }
    end
  end

  # @label With Default Value
  # Select with a pre-selected value
  def with_default_value
    render(Shadcn::SelectComponent.new(name: "timezone", value: "est", placeholder: "Select a timezone")) do |select|
      select.with_item(value: "est") { "Eastern Standard Time (EST)" }
      select.with_item(value: "cst") { "Central Standard Time (CST)" }
      select.with_item(value: "mst") { "Mountain Standard Time (MST)" }
      select.with_item(value: "pst") { "Pacific Standard Time (PST)" }
    end
  end

  # @label With Groups
  # Select with grouped options
  def with_groups
    render(Shadcn::SelectComponent.new(name: "timezone", placeholder: "Select a timezone")) do |select|
      select.with_group(label: "North America") do |group|
        group.with_item(value: "est") { "Eastern Standard Time" }
        group.with_item(value: "cst") { "Central Standard Time" }
        group.with_item(value: "mst") { "Mountain Standard Time" }
        group.with_item(value: "pst") { "Pacific Standard Time" }
      end
      select.with_group(label: "Europe & Africa") do |group|
        group.with_item(value: "gmt") { "Greenwich Mean Time" }
        group.with_item(value: "cet") { "Central European Time" }
        group.with_item(value: "eet") { "Eastern European Time" }
        group.with_item(value: "west") { "Western European Summer Time" }
        group.with_item(value: "cat") { "Central Africa Time" }
        group.with_item(value: "eat") { "East Africa Time" }
      end
      select.with_group(label: "Asia") do |group|
        group.with_item(value: "msk") { "Moscow Time" }
        group.with_item(value: "ist") { "India Standard Time" }
        group.with_item(value: "cst_china") { "China Standard Time" }
        group.with_item(value: "jst") { "Japan Standard Time" }
        group.with_item(value: "kst") { "Korea Standard Time" }
      end
      select.with_group(label: "Australia & Pacific") do |group|
        group.with_item(value: "awst") { "Australian Western Standard Time" }
        group.with_item(value: "acst") { "Australian Central Standard Time" }
        group.with_item(value: "aest") { "Australian Eastern Standard Time" }
        group.with_item(value: "nzst") { "New Zealand Standard Time" }
      end
    end
  end

  # @label Disabled Options
  # Select with some disabled options
  def disabled_options
    render(Shadcn::SelectComponent.new(name: "plan", placeholder: "Select a plan")) do |select|
      select.with_item(value: "free") { "Free" }
      select.with_item(value: "starter") { "Starter" }
      select.with_item(value: "pro") { "Pro" }
      select.with_item(value: "enterprise", disabled: true) { "Enterprise (Coming Soon)" }
    end
  end

  # @label Disabled Select
  # Entire select component disabled
  def disabled_select
    render(Shadcn::SelectComponent.new(name: "status", disabled: true, placeholder: "Select status")) do |select|
      select.with_item(value: "active") { "Active" }
      select.with_item(value: "inactive") { "Inactive" }
      select.with_item(value: "pending") { "Pending" }
    end
  end

  # @label Required Field
  # Select with required validation
  def required_field
    '<form class="space-y-4">
      <div class="space-y-2">
        <label class="text-sm font-medium">Country *</label>
        ' + render_inline(Shadcn::SelectComponent.new(name: "country", required: true, placeholder: "Select a country")) { |select|
          select.with_item(value: "us") { "United States" }
          select.with_item(value: "ca") { "Canada" }
          select.with_item(value: "uk") { "United Kingdom" }
          select.with_item(value: "au") { "Australia" }
        }.to_s + '
        <p class="text-xs text-muted-foreground">This field is required</p>
      </div>
      <button type="submit" class="inline-flex items-center justify-center rounded-md text-sm font-medium bg-primary text-primary-foreground h-9 px-4 py-2">Submit</button>
    </form>'.html_safe
  end

  # @label Framework Selection
  # Select for choosing a framework
  def framework_selection
    render(Shadcn::SelectComponent.new(name: "framework", placeholder: "Select a framework", class_name: "w-[280px]")) do |select|
      select.with_item(value: "next") { "Next.js" }
      select.with_item(value: "sveltekit") { "SvelteKit" }
      select.with_item(value: "nuxt") { "Nuxt.js" }
      select.with_item(value: "remix") { "Remix" }
      select.with_item(value: "astro") { "Astro" }
      select.with_item(value: "rails") { "Ruby on Rails" }
    end
  end

  # @label Email Provider
  # Select for choosing an email provider
  def email_provider
    render(Shadcn::SelectComponent.new(name: "email", value: "gmail", placeholder: "Select email")) do |select|
      select.with_group(label: "Personal") do |group|
        group.with_item(value: "gmail") { "Gmail" }
        group.with_item(value: "yahoo") { "Yahoo Mail" }
        group.with_item(value: "outlook") { "Outlook" }
        group.with_item(value: "icloud") { "iCloud Mail" }
      end
      select.with_group(label: "Business") do |group|
        group.with_item(value: "gsuite") { "Google Workspace" }
        group.with_item(value: "office365") { "Microsoft 365" }
        group.with_item(value: "zoho") { "Zoho Mail" }
      end
    end
  end

  # @label Long List
  # Select with many options
  def long_list
    render(Shadcn::SelectComponent.new(name: "number", placeholder: "Select a number")) do |select|
      (1..50).each do |i|
        select.with_item(value: i.to_s) { "Option #{i}" }
      end
    end
  end

  # @label In Form Layout
  # Select within a complete form layout
  def in_form_layout
    '<div class="max-w-md space-y-6 p-4 border rounded-lg">
      <div>
        <h3 class="text-lg font-semibold">Profile Settings</h3>
        <p class="text-sm text-muted-foreground">Update your profile information</p>
      </div>
      <form class="space-y-4">
        <div class="space-y-2">
          <label class="text-sm font-medium">Username</label>
          <input type="text" placeholder="johndoe" class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm" />
        </div>
        <div class="space-y-2">
          <label class="text-sm font-medium">Email</label>
          <input type="email" placeholder="john@example.com" class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm" />
        </div>
        <div class="space-y-2">
          <label class="text-sm font-medium">Role</label>
          ' + render_inline(Shadcn::SelectComponent.new(name: "role", placeholder: "Select a role")) { |select|
            select.with_item(value: "developer") { "Developer" }
            select.with_item(value: "designer") { "Designer" }
            select.with_item(value: "manager") { "Manager" }
            select.with_item(value: "owner") { "Owner" }
          }.to_s + '
        </div>
        <div class="space-y-2">
          <label class="text-sm font-medium">Timezone</label>
          ' + render_inline(Shadcn::SelectComponent.new(name: "timezone", value: "pst", placeholder: "Select timezone")) { |select|
            select.with_item(value: "est") { "Eastern (EST)" }
            select.with_item(value: "cst") { "Central (CST)" }
            select.with_item(value: "mst") { "Mountain (MST)" }
            select.with_item(value: "pst") { "Pacific (PST)" }
          }.to_s + '
        </div>
        <div class="flex gap-2 pt-2">
          <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-input bg-background h-9 px-4 py-2">Cancel</button>
          <button type="submit" class="inline-flex items-center justify-center rounded-md text-sm font-medium bg-primary text-primary-foreground h-9 px-4 py-2">Save changes</button>
        </div>
      </form>
    </div>'.html_safe
  end
end
