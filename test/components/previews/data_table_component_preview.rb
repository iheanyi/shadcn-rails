# frozen_string_literal: true

# @label Data Table
# @display bg_color "#ffffff"
class DataTableComponentPreview < ViewComponent::Preview
  # @label Default
  # Server-first table with sortable headers, an empty state, and pagination footer.
  def default
    render(Shadcn::DataTableComponent.new(
      rows: invoices,
      sort: "name",
      dir: "asc",
      params: { "q" => "paid", "page" => "2", "sort" => "name", "dir" => "asc" },
      path: "/docs/components/data-table"
    )) do |table|
      table.with_toolbar do
        <<~HTML.html_safe
          <form action="/docs/components/data-table" method="get" class="flex gap-2">
            <input type="search" name="q" value="paid" placeholder="Search invoices..." class="flex h-9 w-full max-w-xs rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm">
            <button type="submit" class="inline-flex h-9 items-center justify-center rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-xs">Search</button>
          </form>
        HTML
      end

      table.with_column(:name, label: "Customer", sortable: true)
      table.with_column(:email, sortable: true)
      table.with_column(:status) do |invoice|
        %(<span class="inline-flex items-center rounded-md border px-2 py-0.5 text-xs font-medium">#{invoice[:status]}</span>).html_safe
      end
      table.with_column(:amount, label: "Amount", sortable: true, align: :end) do |invoice|
        "$#{format('%.2f', invoice[:amount] / 100.0)}"
      end

      table.with_empty_state do
        "No invoices found"
      end

      table.with_footer do
        <<~HTML.html_safe
          <nav role="navigation" aria-label="pagination" class="mx-auto flex w-full justify-center">
            <ul class="flex flex-row items-center gap-1">
              <li><a href="/docs/components/data-table?page=1" class="inline-flex h-9 px-4 py-2 items-center justify-center rounded-md text-sm">Previous</a></li>
              <li><a href="/docs/components/data-table?page=1" class="inline-flex h-9 w-9 items-center justify-center rounded-md text-sm">1</a></li>
              <li><a href="/docs/components/data-table?page=2" aria-current="page" class="inline-flex h-9 w-9 items-center justify-center rounded-md border text-sm">2</a></li>
              <li><a href="/docs/components/data-table?page=3" class="inline-flex h-9 w-9 items-center justify-center rounded-md text-sm">3</a></li>
              <li><a href="/docs/components/data-table?page=3" class="inline-flex h-9 px-4 py-2 items-center justify-center rounded-md text-sm">Next</a></li>
            </ul>
          </nav>
        HTML
      end
    end
  end

  private

  def invoices
    [
      { name: "Olivia Martin", email: "olivia@example.com", status: "Paid", amount: 1999 },
      { name: "Jackson Lee", email: "jackson@example.com", status: "Paid", amount: 3900 },
      { name: "Sofia Davis", email: "sofia@example.com", status: "Paid", amount: 3900 }
    ]
  end
end
