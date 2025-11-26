# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "minitest/autorun"
require "view_component/test_helpers"
require "view_component/test_case"

# Load all components
Dir[File.expand_path("../app/components/**/*.rb", __dir__)].each { |f| require f }

class ViewComponent::TestCase
  include ViewComponent::TestHelpers

  def render_inline(component, &block)
    super
  end
end

# Custom assertions for component testing
module ComponentAssertions
  def assert_has_class(class_name, message = nil)
    assert page.has_css?(".#{class_name}"), message || "Expected element with class '#{class_name}'"
  end

  def assert_has_attribute(attribute, value = nil, message = nil)
    if value
      assert page.has_css?("[#{attribute}='#{value}']"), message || "Expected element with #{attribute}='#{value}'"
    else
      assert page.has_css?("[#{attribute}]"), message || "Expected element with #{attribute}"
    end
  end

  def assert_has_role(role, message = nil)
    assert page.has_css?("[role='#{role}']"), message || "Expected element with role='#{role}'"
  end

  def assert_has_aria(attribute, value, message = nil)
    assert page.has_css?("[aria-#{attribute}='#{value}']"), message || "Expected element with aria-#{attribute}='#{value}'"
  end
end
