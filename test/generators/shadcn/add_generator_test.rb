# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/shadcn/add/add_generator"

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

  private

  def write_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
