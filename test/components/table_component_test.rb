# frozen_string_literal: true

require "test_helper"

class TableComponentTest < ViewComponent::TestCase
  def test_renders_table_in_scrollable_container
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    wrapper_classes = page.find("div")["class"].split

    assert_includes wrapper_classes, "relative"
    assert_includes wrapper_classes, "w-full"
    assert_includes wrapper_classes, "overflow-x-auto"
    refute_includes wrapper_classes, "overflow-auto"
    refute_includes all_class_tokens, "data-[size=default]"
    assert_selector "table"
  end

  def test_renders_table_with_base_styles
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    assert_selector "table.w-full"
    assert_selector "table.caption-bottom"
    assert_selector "table.text-sm"
  end

  def test_renders_new_york_v4_row_head_and_cell_styles
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Name" }
        end
      end
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Alice" }
        end
      end
    end

    row_classes = page.find("tbody tr")["class"].split
    head_classes = page.find("th")["class"].split
    cell_classes = page.find("td")["class"].split

    assert_includes row_classes, "has-aria-expanded:bg-muted/50"
    assert_includes head_classes, "whitespace-nowrap"
    assert_includes head_classes, "text-foreground"
    assert_includes cell_classes, "whitespace-nowrap"
    refute_includes head_classes, "text-muted-foreground"
    refute_includes all_class_tokens, "data-[size=default]"
  end

  def test_renders_table_header
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Name" }
          row.with_head { "Email" }
        end
      end
    end

    assert_selector "thead"
    assert_selector "th", text: "Name"
    assert_selector "th", text: "Email"
  end

  def test_renders_table_body
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "John" }
          row.with_cell { "john@example.com" }
        end
      end
    end

    assert_selector "tbody"
    assert_selector "td", text: "John"
    assert_selector "td", text: "john@example.com"
  end

  def test_renders_multiple_rows
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Row 1" }
        end
        body.with_row do |row|
          row.with_cell { "Row 2" }
        end
        body.with_row do |row|
          row.with_cell { "Row 3" }
        end
      end
    end

    assert_selector "tr", count: 3
    assert_selector "td", count: 3
  end

  def test_renders_table_caption
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_caption { "A list of your recent invoices." }
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    assert_selector "caption", text: "A list of your recent invoices."
  end

  def test_renders_table_footer
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
      table.with_footer do |footer|
        footer.with_row do |row|
          row.with_cell { "Total" }
          row.with_cell { "$250.00" }
        end
      end
    end

    assert_selector "tfoot"
    assert_selector "tfoot td", text: "Total"
    assert_selector "tfoot td", text: "$250.00"
  end

  def test_renders_complete_table
    render_inline(Shadcn::TableComponent.new) do |table|
      table.with_caption { "Users" }
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Name" }
          row.with_head { "Role" }
        end
      end
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Alice" }
          row.with_cell { "Admin" }
        end
      end
      table.with_footer do |footer|
        footer.with_row do |row|
          row.with_cell { "Total: 1" }
        end
      end
    end

    assert_selector "caption", text: "Users"
    assert_selector "thead th", count: 2
    assert_selector "tbody td", count: 2
    assert_selector "tfoot td", count: 1
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::TableComponent.new(class_name: "my-table")) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    assert_selector "div.my-table"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::TableComponent.new(class: "alias-class")) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::TableComponent.new(data: { testid: "table" })) do |table|
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell { "Data" }
        end
      end
    end

    assert_selector "[data-testid='table']"
  end

  private

  def all_class_tokens
    page.all("[class]").flat_map { |node| node["class"].split }
  end
end
