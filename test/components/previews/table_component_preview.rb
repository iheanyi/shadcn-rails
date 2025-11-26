# frozen_string_literal: true

# @label Table
# @display bg_color "#ffffff"
class TableComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic table with header and rows
  def default
    render(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Name" }
          row.with_head { "Email" }
          row.with_head { "Role" }
          row.with_head { "Status" }
        end
      end
      table.with_body do |body|
        users.each do |user|
          body.with_row do |row|
            row.with_cell { user[:name] }
            row.with_cell { user[:email] }
            row.with_cell { user[:role] }
            row.with_cell { badge_html(user[:status]) }
          end
        end
      end
    end
  end

  # @label With Caption
  # Table with a caption describing the data
  def with_caption
    render(Shadcn::TableComponent.new) do |table|
      table.with_caption { "A list of your recent invoices." }
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Invoice" }
          row.with_head { "Status" }
          row.with_head { "Method" }
          row.with_head { "Amount" }
        end
      end
      table.with_body do |body|
        invoices.each do |invoice|
          body.with_row do |row|
            row.with_cell { invoice[:number] }
            row.with_cell { badge_html(invoice[:status]) }
            row.with_cell { invoice[:method] }
            row.with_cell { invoice[:amount] }
          end
        end
      end
    end
  end

  # @label With Footer
  # Table with footer row for totals or summary
  def with_footer
    render(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Product" }
          row.with_head { "Quantity" }
          row.with_head { "Price" }
          row.with_head { "Total" }
        end
      end
      table.with_body do |body|
        products.each do |product|
          body.with_row do |row|
            row.with_cell { product[:name] }
            row.with_cell { product[:quantity].to_s }
            row.with_cell { product[:price] }
            row.with_cell { product[:total] }
          end
        end
      end
      table.with_footer do |footer|
        footer.with_row do |row|
          row.with_cell(class_name: "font-medium", colspan: 3) { "Total" }
          row.with_cell(class_name: "font-medium") { "$890.00" }
        end
      end
    end
  end

  # @label Striped Rows
  # Table with alternating row colors
  def striped
    render(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "ID" }
          row.with_head { "Name" }
          row.with_head { "Department" }
          row.with_head { "Salary" }
        end
      end
      table.with_body do |body|
        employees.each_with_index do |employee, index|
          body.with_row(class_name: index.even? ? "bg-muted/50" : "") do |row|
            row.with_cell { employee[:id] }
            row.with_cell { employee[:name] }
            row.with_cell { employee[:department] }
            row.with_cell { employee[:salary] }
          end
        end
      end
    end
  end

  # @label With Actions
  # Table with action buttons in cells
  def with_actions
    render(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "User" }
          row.with_head { "Email" }
          row.with_head { "Role" }
          row.with_head(class_name: "text-right") { "Actions" }
        end
      end
      table.with_body do |body|
        users.each do |user|
          body.with_row do |row|
            row.with_cell { user[:name] }
            row.with_cell { user[:email] }
            row.with_cell { user[:role] }
            row.with_cell(class_name: "text-right") do
              <<~HTML.html_safe
                <div class="flex justify-end gap-2">
                  #{button_html(:ghost, "Edit", "h-8 px-2 text-xs")}
                  #{button_html(:ghost, "Delete", "h-8 px-2 text-xs text-destructive")}
                </div>
              HTML
            end
          end
        end
      end
    end
  end

  # @label Selectable Rows
  # Table with selectable rows using checkboxes
  def selectable
    render(Shadcn::TableComponent.new) do |table|
      table.with_header do |header|
        header.with_row do |row|
          row.with_head(class_name: "w-12") do
            '<input type="checkbox" class="rounded border-input">'.html_safe
          end
          row.with_head { "Task" }
          row.with_head { "Priority" }
          row.with_head { "Assignee" }
          row.with_head { "Due Date" }
        end
      end
      table.with_body do |body|
        tasks.each do |task|
          body.with_row(selected: task[:selected]) do |row|
            row.with_cell(class_name: "w-12") do
              %(<input type="checkbox" #{task[:selected] ? 'checked' : ''} class="rounded border-input">).html_safe
            end
            row.with_cell { task[:name] }
            row.with_cell { badge_html(task[:priority]) }
            row.with_cell { task[:assignee] }
            row.with_cell { task[:due_date] }
          end
        end
      end
    end
  end

  # @label Empty State
  # Table with no data showing empty state
  def empty_state
    render(Shadcn::TableComponent.new) do |table|
      table.with_caption { "No results found." }
      table.with_header do |header|
        header.with_row do |row|
          row.with_head { "Name" }
          row.with_head { "Email" }
          row.with_head { "Role" }
          row.with_head { "Status" }
        end
      end
      table.with_body do |body|
        body.with_row do |row|
          row.with_cell(colspan: 4, class_name: "h-24 text-center") do
            '<p class="text-muted-foreground">No users found.</p>'.html_safe
          end
        end
      end
    end
  end

  private

  def users
    [
      { name: "Alice Johnson", email: "alice@example.com", role: "Admin", status: "Active" },
      { name: "Bob Smith", email: "bob@example.com", role: "User", status: "Active" },
      { name: "Charlie Brown", email: "charlie@example.com", role: "Manager", status: "Inactive" },
      { name: "Diana Prince", email: "diana@example.com", role: "User", status: "Active" }
    ]
  end

  def invoices
    [
      { number: "INV-001", status: "Paid", method: "Credit Card", amount: "$250.00" },
      { number: "INV-002", status: "Pending", method: "PayPal", amount: "$150.00" },
      { number: "INV-003", status: "Paid", method: "Bank Transfer", amount: "$350.00" },
      { number: "INV-004", status: "Failed", method: "Credit Card", amount: "$450.00" }
    ]
  end

  def products
    [
      { name: "Laptop Pro", quantity: 2, price: "$299.00", total: "$598.00" },
      { name: "Wireless Mouse", quantity: 4, price: "$25.00", total: "$100.00" },
      { name: "USB-C Cable", quantity: 3, price: "$12.00", total: "$36.00" },
      { name: "Monitor Stand", quantity: 1, price: "$156.00", total: "$156.00" }
    ]
  end

  def employees
    [
      { id: "E001", name: "John Doe", department: "Engineering", salary: "$85,000" },
      { id: "E002", name: "Jane Smith", department: "Design", salary: "$78,000" },
      { id: "E003", name: "Mike Johnson", department: "Marketing", salary: "$72,000" },
      { id: "E004", name: "Sarah Williams", department: "Sales", salary: "$68,000" },
      { id: "E005", name: "Tom Brown", department: "Engineering", salary: "$92,000" }
    ]
  end

  def tasks
    [
      { name: "Implement authentication", priority: "High", assignee: "Alice", due_date: "2024-01-15", selected: true },
      { name: "Design landing page", priority: "Medium", assignee: "Bob", due_date: "2024-01-18", selected: false },
      { name: "Write documentation", priority: "Low", assignee: "Charlie", due_date: "2024-01-20", selected: true },
      { name: "Fix login bug", priority: "High", assignee: "Diana", due_date: "2024-01-16", selected: false }
    ]
  end

  def badge_html(status)
    variant_classes = case status.downcase
    when "active", "paid", "high"
      "border-transparent bg-primary text-primary-foreground"
    when "pending", "medium"
      "border-transparent bg-secondary text-secondary-foreground"
    when "inactive", "failed", "low"
      "border-transparent bg-destructive text-destructive-foreground"
    else
      "border-transparent bg-secondary text-secondary-foreground"
    end

    base_classes = "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors"
    classes = [base_classes, variant_classes].join(" ")
    %(<span class="#{classes}">#{status}</span>).html_safe
  end

  def button_html(variant, text, extra_class = nil)
    base_classes = "inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2"

    variant_classes = case variant
    when :default
      "bg-primary text-primary-foreground hover:bg-primary/90"
    when :destructive
      "bg-destructive text-destructive-foreground hover:bg-destructive/90"
    when :outline
      "border border-input bg-background hover:bg-accent hover:text-accent-foreground"
    when :secondary
      "bg-secondary text-secondary-foreground hover:bg-secondary/80"
    when :ghost
      "hover:bg-accent hover:text-accent-foreground"
    when :link
      "text-primary underline-offset-4 hover:underline"
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
