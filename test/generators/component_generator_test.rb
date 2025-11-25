# frozen_string_literal: true

require "test_helper"
require "generators/shadcn/component_generator"
require "rails/generators/test_case"

class ComponentGeneratorTest < Rails::Generators::TestCase
  tests Shadcn::ComponentGenerator
  destination File.expand_path("../../tmp", __dir__)

  setup do
    prepare_destination
    # Create necessary directories
    FileUtils.mkdir_p(File.join(destination_root, "app/components/ui"))

    # Create base_component.rb (normally created by install generator)
    File.write(
      File.join(destination_root, "app/components/ui/base_component.rb"),
      "module Ui\n  class BaseComponent < ApplicationComponent\n  end\nend\n"
    )
  end

  test "generates button component" do
    run_generator ["button"]
    assert_file "app/components/ui/button_component.rb" do |content|
      assert_match(/module Ui/, content)
      assert_match(/class ButtonComponent < BaseComponent/, content)
      assert_match(/VARIANTS/, content)
      assert_match(/SIZES/, content)
    end
    assert_file "app/components/ui/button_component.html.erb"
  end

  test "generates card component" do
    run_generator ["card"]
    assert_file "app/components/ui/card_component.rb" do |content|
      assert_match(/class CardComponent < BaseComponent/, content)
      assert_match(/renders_one :header/, content)
      assert_match(/renders_one :content/, content)
      assert_match(/renders_one :footer/, content)
    end
  end

  test "generates input component" do
    run_generator ["input"]
    assert_file "app/components/ui/input_component.rb" do |content|
      assert_match(/class InputComponent < BaseComponent/, content)
      assert_match(/attr_reader :type/, content)
    end
  end

  test "generates multiple components" do
    run_generator ["button", "card", "input"]
    assert_file "app/components/ui/button_component.rb"
    assert_file "app/components/ui/card_component.rb"
    assert_file "app/components/ui/input_component.rb"
  end

  test "respects custom path option" do
    FileUtils.mkdir_p(File.join(destination_root, "app/views/ui"))
    run_generator ["button", "--path=app/views/ui"]
    assert_file "app/views/ui/button_component.rb"
  end

  test "skips existing components without force" do
    # Create existing component
    File.write(
      File.join(destination_root, "app/components/ui/button_component.rb"),
      "# existing content\n"
    )

    run_generator ["button"]

    assert_file "app/components/ui/button_component.rb" do |content|
      assert_match(/# existing content/, content)
    end
  end

  test "overwrites existing components with force option" do
    # Create existing component
    File.write(
      File.join(destination_root, "app/components/ui/button_component.rb"),
      "# existing content\n"
    )

    run_generator ["button", "--force"]

    assert_file "app/components/ui/button_component.rb" do |content|
      assert_match(/class ButtonComponent/, content)
      refute_match(/# existing content/, content)
    end
  end

  test "fails gracefully for unknown components" do
    output = run_generator ["unknown_component"]
    assert_match(/Unknown component/, output)
  end
end
