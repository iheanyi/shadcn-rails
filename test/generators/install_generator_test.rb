# frozen_string_literal: true

require "test_helper"
require "generators/shadcn/install_generator"
require "rails/generators/test_case"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Shadcn::InstallGenerator
  destination File.expand_path("../../tmp", __dir__)

  setup do
    prepare_destination
    # Create necessary directories
    FileUtils.mkdir_p(File.join(destination_root, "app/helpers"))
    FileUtils.mkdir_p(File.join(destination_root, "app/components"))
    FileUtils.mkdir_p(File.join(destination_root, "config/initializers"))
    FileUtils.mkdir_p(File.join(destination_root, "app/assets/stylesheets"))

    # Create a minimal application_helper.rb
    File.write(
      File.join(destination_root, "app/helpers/application_helper.rb"),
      "module ApplicationHelper\nend\n"
    )
  end

  test "creates components directory" do
    run_generator
    assert_directory "app/components/ui"
  end

  test "creates base_component.rb" do
    run_generator
    assert_file "app/components/ui/base_component.rb" do |content|
      assert_match(/module Ui/, content)
      assert_match(/class BaseComponent/, content)
    end
  end

  test "creates application_component.rb if not exists" do
    run_generator
    assert_file "app/components/application_component.rb" do |content|
      assert_match(/class ApplicationComponent < ViewComponent::Base/, content)
    end
  end

  test "creates initializer" do
    run_generator
    assert_file "config/initializers/shadcn.rb" do |content|
      assert_match(/Shadcn::Rails.configure/, content)
    end
  end

  test "creates shadcn.css" do
    run_generator
    assert_file "app/assets/stylesheets/shadcn.css" do |content|
      assert_match(/--background:/, content)
      assert_match(/--primary:/, content)
    end
  end

  test "creates component_helpers.rb" do
    run_generator
    assert_file "app/helpers/concerns/shadcn_helpers.rb" do |content|
      assert_match(/module ShadcnHelpers/, content)
      assert_match(/def cn/, content)
    end
  end

  test "respects custom components_path option" do
    run_generator ["--components-path=app/views/ui"]
    assert_directory "app/views/ui"
    assert_file "app/views/ui/base_component.rb"
  end

  test "skips tailwind with --skip-tailwind option" do
    run_generator ["--skip-tailwind"]
    assert_no_file "app/assets/stylesheets/shadcn.css"
  end
end
