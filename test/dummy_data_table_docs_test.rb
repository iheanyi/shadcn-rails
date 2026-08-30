# frozen_string_literal: true

require "test_helper"

class DummyDataTableDocsTest < ActionDispatch::IntegrationTest
  def test_live_demo_uses_dummy_host_controller
    refute Shadcn::Rails::Registry.fetch("data_table").controllers.any?,
      "Data Table should stay ViewComponent-only and not ship Stimulus"

    get "/docs/components/data-table", params: { sort: "name", dir: "desc" }

    assert_response :success
    assert_select "turbo-frame#data-table-demo"
    assert_select "form[data-controller='docs--live-filter'][data-turbo-frame='data-table-demo'][method='get']"
    assert_select "input[name='sort'][type='hidden'][value='name']"
    assert_select "input[name='dir'][type='hidden'][value='desc']"
    assert_select "input#data-table-search[name='q'][data-action='input->docs--live-filter#submitLater']"
    assert_select "select#data-table-status[name='status'][data-action='change->docs--live-filter#submitNow']"
    assert_select "select#data-table-status[onchange]", false
    assert_select "button[type='submit']", text: "Apply"
    assert_select "a[href='/docs/components/data-table']", text: "Reset"
  end

  def test_docs_controller_filters_data_table_by_search_and_status
    get "/docs/components/data-table", params: { q: "example.com", status: "Failed" }

    assert_response :success
    assert_includes response.body, "2 invoices found"
    assert_includes response.body, "Noah Garcia"
    assert_includes response.body, "Amelia Brown"
    refute_includes response.body, "Olivia Martin"
    refute_includes response.body, "Lucas Miller"
  end

  def test_docs_controller_shows_empty_state_when_filters_match_nothing
    get "/docs/components/data-table", params: { q: "olivia", status: "Processing" }

    assert_response :success
    assert_includes response.body, "0 invoices found"
    assert_includes response.body, "No invoices found"
    assert_includes response.body, "Try a different search term or status filter."
  end
end
