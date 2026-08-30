# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/shadcn/add/add_generator"
require "open3"

class ShadcnAddGeneratorTest < Rails::Generators::TestCase
  tests Shadcn::Generators::AddGenerator
  destination File.expand_path("../../tmp/generators/shadcn_add", __dir__)

  setup :prepare_destination

  def test_dialog_copies_complete_component_unit
    run_generator %w[dialog]

    assert_file "app/components/shadcn/dialog_component.rb"
    assert_file "app/components/shadcn/dialog_component.html.erb"
    assert_file "app/components/shadcn/dialog_content_component.rb"
    assert_file "app/components/shadcn/dialog_description_component.rb"
    assert_file "app/components/shadcn/dialog_footer_component.rb"
    assert_file "app/components/shadcn/dialog_header_component.rb"
    assert_file "app/components/shadcn/dialog_title_component.rb"
    assert_file "app/javascript/controllers/shadcn/dialog_controller.js"
  end

  def test_dialog_add_fills_missing_files_when_root_already_exists
    write_file "app/components/shadcn/dialog_component.rb", "# existing app dialog husk\n"

    run_generator %w[dialog]

    assert_file "app/components/shadcn/dialog_component.rb", "# existing app dialog husk\n"
    assert_file "app/components/shadcn/dialog_content_component.rb"
    assert_file "app/components/shadcn/dialog_header_component.rb"
    assert_file "app/components/shadcn/dialog_title_component.rb"
    assert_file "app/components/shadcn/dialog_component.html.erb"
  end

  def test_dropdown_menu_copies_controller_dependencies_with_app_relative_imports
    run_generator %w[dropdown_menu]

    assert_file "app/components/shadcn/dropdown_menu_component.rb"
    assert_file "app/components/shadcn/dropdown_menu_content_component.rb"
    assert_file "app/components/shadcn/dropdown_menu_item_component.rb"
    assert_file "app/components/shadcn/dropdown_menu_shortcut_component.rb"

    assert_file "app/javascript/controllers/shadcn/dropdown_controller.js" do |content|
      assert_includes content, %(import BaseMenuController from "./base_menu_controller")
      assert_includes content, %(import { positionFloating } from "./utils/floating")
      refute_includes content, %(../utils/floating)
    end

    assert_file "app/javascript/controllers/shadcn/base_menu_controller.js"
    assert_file "app/javascript/controllers/shadcn/utils/floating.js"
  end

  def test_hyphenated_component_names_are_accepted
    run_generator %w[dropdown-menu --exclude-controllers]

    assert_file "app/components/shadcn/dropdown_menu_component.rb"
    assert_file "app/components/shadcn/dropdown_menu_content_component.rb"
    assert_no_file "app/javascript/controllers/shadcn/dropdown_controller.js"
  end

  def test_empty_and_item_are_available_component_units
    run_generator %w[empty item --exclude-controllers]

    assert_file "app/components/shadcn/empty_component.rb"
    assert_file "app/components/shadcn/empty_content_component.rb"
    assert_file "app/components/shadcn/empty_description_component.rb"
    assert_file "app/components/shadcn/empty_header_component.rb"
    assert_file "app/components/shadcn/empty_media_component.rb"
    assert_file "app/components/shadcn/empty_title_component.rb"

    assert_file "app/components/shadcn/item_component.rb"
    assert_file "app/components/shadcn/item_actions_component.rb"
    assert_file "app/components/shadcn/item_content_component.rb"
    assert_file "app/components/shadcn/item_description_component.rb"
    assert_file "app/components/shadcn/item_footer_component.rb"
    assert_file "app/components/shadcn/item_group_component.rb"
    assert_file "app/components/shadcn/item_header_component.rb"
    assert_file "app/components/shadcn/item_media_component.rb"
    assert_file "app/components/shadcn/item_separator_component.rb"
    assert_file "app/components/shadcn/item_title_component.rb"
  end

  def test_resizable_copies_panel_group_unit
    run_generator %w[resizable --exclude-controllers]

    assert_file "app/components/shadcn/resizable_panel_group_component.rb"
    assert_file "app/components/shadcn/resizable_panel_component.rb"
    assert_file "app/components/shadcn/resizable_handle_component.rb"
  end

  def test_data_table_copies_table_dependency
    run_generator %w[data_table]

    assert_file "app/components/shadcn/data_table_component.rb"
    assert_file "app/components/shadcn/data_table_column_component.rb"
    assert_file "app/components/shadcn/data_table_component.html.erb"

    assert_file "app/components/shadcn/table_component.rb"
    assert_file "app/components/shadcn/table_component.html.erb"
    assert_file "app/components/shadcn/table_body_component.rb"
    assert_file "app/components/shadcn/table_cell_component.rb"
    assert_file "app/components/shadcn/table_head_component.rb"
    assert_file "app/components/shadcn/table_header_component.rb"
    assert_file "app/components/shadcn/table_row_component.rb"

    assert_file "app/components/shadcn/empty_component.rb"
    assert_file "app/components/shadcn/empty_content_component.rb"
    assert_file "app/components/shadcn/empty_description_component.rb"
    assert_file "app/components/shadcn/empty_header_component.rb"
    assert_file "app/components/shadcn/empty_media_component.rb"
    assert_file "app/components/shadcn/empty_title_component.rb"
  end

  def test_dialog_source_location_is_app_after_add
    within_clean_dummy_app do |dummy_root|
      run_dummy_command!(dummy_root, "rails", "generate", "shadcn:add", "dialog")

      output = run_dummy_command!(
        dummy_root,
        "rails",
        "runner",
        "puts Shadcn::DialogContentComponent.instance_method(:call).source_location.first; puts Shadcn::ButtonComponent.instance_method(:button_classes).source_location.first"
      )
      dialog_content_source, button_source = output.lines.map(&:strip)

      assert_includes dialog_content_source, File.join("test", "dummy", "app", "components", "shadcn", "dialog_content_component.rb")
      assert_includes button_source, File.join("app", "components", "shadcn", "button_component.rb")
      refute_includes button_source, File.join("test", "dummy", "app", "components")
    end
  end

  private

  def write_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end

  def within_clean_dummy_app
    dummy_root = File.expand_path("../../dummy", __dir__)
    cleanup_dummy_generated_files(dummy_root)

    yield dummy_root
  ensure
    cleanup_dummy_generated_files(dummy_root) if dummy_root
  end

  def cleanup_dummy_generated_files(dummy_root)
    FileUtils.rm_rf(File.join(dummy_root, "app/components"))
    FileUtils.rm_rf(File.join(dummy_root, "app/javascript/controllers/shadcn"))
    FileUtils.rm_rf(File.join(dummy_root, "log"))
    FileUtils.rm_rf(File.join(dummy_root, "tmp"))
  end

  def run_dummy_command!(dummy_root, *command)
    env = { "BUNDLE_GEMFILE" => File.expand_path("../../../Gemfile", __dir__) }
    stdout, stderr, status = Open3.capture3(env, "bundle", "exec", *command, chdir: dummy_root)

    assert status.success?, "Expected #{command.join(' ')} to succeed.\nSTDOUT:\n#{stdout}\nSTDERR:\n#{stderr}"
    stdout
  end
end
