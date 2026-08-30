# frozen_string_literal: true

require "test_helper"

class ShadcnRegistryTest < Minitest::Test
  def test_available_components_comes_from_registry_keys
    assert_includes Shadcn::Rails.available_components, :dialog
    assert_includes Shadcn::Rails.available_components, :button
    refute_includes Shadcn::Rails.available_components, :dialog_content
  end

  def test_dialog_unit_lists_complete_file_graph
    unit = Shadcn::Rails::Registry.fetch("dialog")

    assert_equal "dialog", unit.name
    assert_includes unit.ruby_files, "app/components/shadcn/dialog_component.rb"
    assert_includes unit.ruby_files, "app/components/shadcn/dialog_content_component.rb"
    assert_includes unit.ruby_files, "app/components/shadcn/dialog_header_component.rb"
    assert_includes unit.ruby_files, "app/components/shadcn/dialog_title_component.rb"
    assert_includes unit.templates, "app/components/shadcn/dialog_component.html.erb"
    assert_includes unit.controllers, "app/assets/javascripts/shadcn/controllers/dialog_controller.js"
  end

  def test_data_table_unit_depends_on_table_unit
    unit = Shadcn::Rails::Registry.fetch("data-table")

    assert_equal "data_table", unit.name
    assert_includes unit.ruby_files, "app/components/shadcn/data_table_component.rb"
    assert_includes unit.ruby_files, "app/components/shadcn/data_table_column_component.rb"
    assert_includes unit.templates, "app/components/shadcn/data_table_component.html.erb"
    assert_includes unit.depends_on, "table"
    assert_includes unit.depends_on, "empty"
  end

  def test_registry_normalizes_hyphenated_names
    assert_equal Shadcn::Rails::Registry.fetch("dropdown_menu"), Shadcn::Rails::Registry.fetch("dropdown-menu")
  end
end
