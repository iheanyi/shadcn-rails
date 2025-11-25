# frozen_string_literal: true

require "test_helper"

class Shadcn::Rails::ConfigurationTest < ActiveSupport::TestCase
  setup do
    @configuration = Shadcn::Rails::Configuration.new
  end

  test "sets default components_path" do
    assert_equal "app/components/ui", @configuration.components_path
  end

  test "sets default tailwind_config_path" do
    assert_equal "config/tailwind.config.js", @configuration.tailwind_config_path
  end

  test "sets default styles" do
    assert_equal "rounded-md", @configuration.default_styles[:rounded]
    assert_equal "shadow-sm", @configuration.default_styles[:shadow]
    assert_equal "transition-colors", @configuration.default_styles[:transition]
  end

  test "allows setting custom components path" do
    @configuration.components_path = "app/views/ui"
    assert_equal "app/views/ui", @configuration.components_path
  end

  test "allows setting custom tailwind config path" do
    @configuration.tailwind_config_path = "tailwind.config.js"
    assert_equal "tailwind.config.js", @configuration.tailwind_config_path
  end
end
