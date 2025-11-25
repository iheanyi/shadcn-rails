# frozen_string_literal: true

require "test_helper"

class Shadcn::RailsTest < ActiveSupport::TestCase
  test "has a version number" do
    assert_not_nil Shadcn::Rails::VERSION
  end

  test "configuration returns a Configuration instance" do
    assert_instance_of Shadcn::Rails::Configuration, Shadcn::Rails.configuration
  end

  test "configuration has default components_path" do
    assert_equal "app/components/ui", Shadcn::Rails.configuration.components_path
  end

  test "configuration has default tailwind_config_path" do
    assert_equal "config/tailwind.config.js", Shadcn::Rails.configuration.tailwind_config_path
  end

  test "configure allows setting configuration options" do
    original_path = Shadcn::Rails.configuration.components_path

    Shadcn::Rails.configure do |config|
      config.components_path = "app/views/components"
    end

    assert_equal "app/views/components", Shadcn::Rails.configuration.components_path

    # Reset
    Shadcn::Rails.reset_configuration!
    assert_equal "app/components/ui", Shadcn::Rails.configuration.components_path
  end

  test "available_components returns an array" do
    assert_kind_of Array, Shadcn::Rails.available_components
    assert_includes Shadcn::Rails.available_components, "button"
    assert_includes Shadcn::Rails.available_components, "card"
    assert_includes Shadcn::Rails.available_components, "input"
  end

  test "component_exists? returns true for existing components" do
    assert Shadcn::Rails.component_exists?(:button)
    assert Shadcn::Rails.component_exists?("card")
  end

  test "component_exists? returns false for non-existing components" do
    refute Shadcn::Rails.component_exists?(:nonexistent)
  end

  test "root returns gem root path" do
    assert_kind_of Pathname, Shadcn::Rails.root
  end

  test "components_path returns path to component templates" do
    assert_kind_of Pathname, Shadcn::Rails.components_path
    assert_match(/templates\/components/, Shadcn::Rails.components_path.to_s)
  end
end
