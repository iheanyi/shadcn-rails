# frozen_string_literal: true

# @label Native Select
# @display bg_color "#ffffff"
class NativeSelectComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic native select
  def default
    render(Shadcn::NativeSelectComponent.new(name: "framework")) do |select|
      select.with_option(value: "", disabled: true, selected: true) { "Select a framework" }
      select.with_option(value: "rails") { "Ruby on Rails" }
      select.with_option(value: "stimulus") { "Stimulus" }
      select.with_option(value: "turbo") { "Turbo" }
    end
  end

  # @label With Optgroups
  # Native select with grouped options
  def with_optgroups
    render(Shadcn::NativeSelectComponent.new(name: "car")) do |select|
      select.with_optgroup(label: "Frameworks") do |group|
        group.with_option(value: "rails") { "Ruby on Rails" }
        group.with_option(value: "stimulus") { "Stimulus" }
      end
      select.with_optgroup(label: "Languages") do |group|
        group.with_option(value: "ruby") { "Ruby" }
        group.with_option(value: "javascript") { "JavaScript" }
      end
    end
  end

  # @label Disabled
  # Disabled native select
  def disabled
    render(Shadcn::NativeSelectComponent.new(name: "status", disabled: true)) do |select|
      select.with_option(value: "active", selected: true) { "Active" }
      select.with_option(value: "archived") { "Archived" }
    end
  end

  # @label Required
  # Required native select
  def required
    render(Shadcn::NativeSelectComponent.new(name: "role", required: true)) do |select|
      select.with_option(value: "", disabled: true, selected: true) { "Select a role" }
      select.with_option(value: "admin") { "Admin" }
      select.with_option(value: "member") { "Member" }
    end
  end

  # @label Form Example
  # Native select in a form context
  def form_example
    render(Shadcn::NativeSelectComponent.new(name: "user[timezone]", id: "user_timezone")) do |select|
      select.with_option(value: "utc", selected: true) { "UTC" }
      select.with_option(value: "est") { "Eastern Time" }
      select.with_option(value: "pst") { "Pacific Time" }
    end
  end
end
