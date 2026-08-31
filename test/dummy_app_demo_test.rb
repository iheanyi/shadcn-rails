# frozen_string_literal: true

require "test_helper"

class DummyAppDemoTest < ActionDispatch::IntegrationTest
  APP_SOURCE_PATHS = [
    Rails.root.join("app/controllers/app_controller.rb"),
    Rails.root.join("app/views/layouts/app.html.erb"),
    *Rails.root.join("app/views/app").glob("*.html.erb")
  ].freeze

  test "app root and dashboard render with shipped assets" do
    get "/app"

    assert_response :success
    assert_select "script[src*='application']"
    assert_select "link[href*='tailwind']"
    assert_select "link[href*='shadcn/components']"
    assert_no_match %r{unpkg\.com/@hotwired/stimulus}, response.body

    get "/app/dashboard"

    assert_response :success
    assert_select "div[data-controller~='shadcn--chart']"
    assert_select "canvas[data-shadcn--chart-target='canvas']"
    assert_select "caption", text: /transactions found/
    assert_select "a[href*='sort=customer'][href*='dir=asc']", minimum: 1
  end

  test "dashboard data table supports get filters and kaminari pagination params" do
    get "/app/dashboard", params: { page: 2, q: "email", status: "Completed", sort: "amount", dir: "desc" }

    assert_response :success
    assert_select "input[name='q'][value='email']"
    assert_select "select[name='status'] option[value='Completed'][selected]"
    assert_select "a[aria-current='page']", text: "2"
  end

  test "settings renders form_with builder controls and submits with get params" do
    get "/app/settings", params: {
      settings: {
        first_name: "Ada",
        language: "fr",
        timezone: "gmt",
        security_alerts: "0",
        push_mentions: "1"
      }
    }

    assert_response :success
    assert_select "form[method='get'][action='/app/settings']", minimum: 1
    assert_select "input[name='settings[first_name]'][id='settings_first_name'][value='Ada']"
    assert_select "select[name='settings[language]'][id='settings_language'] option[value='fr'][selected]"
    assert_select "select[name='settings[timezone]'][id='settings_timezone'] option[value='gmt'][selected]"
    assert_select "input[type='checkbox'][name='settings[security_alerts]'][id='settings_security_alerts']"
    assert_select "input[type='checkbox'][name='settings[push_mentions]'][id='settings_push_mentions'][checked]"
    assert_select "button[type='submit']", text: "Save", minimum: 1
    assert_select "button[role='combobox']", 0
  end

  test "notifications use shipped sonner and dropdown menu APIs" do
    get "/app/notifications"

    assert_response :success
    assert_select "div[data-controller~='shadcn--sonner']"
    assert_select "button[data-action='click->shadcn--sonner#demo']", text: /Mark all as read/
    assert_select "div[data-controller~='shadcn--dropdown']", minimum: 1
  end

  test "scoped app source has no museum layout or private component api usage" do
    source = APP_SOURCE_PATHS.map { |path| File.read(path) }.join("\n")

    assert_no_match %r{unpkg\.com/@hotwired/stimulus}, source
    assert_no_match(/File\.read\(.*components\.css.*html_safe/m, source)
    assert_no_match(/Shadcn::\w+Component\.new/, source)
    assert_no_match(/with_image/, source)
    assert_no_match(/with_addon/, source)
    assert_no_match(/with_content\b/, source)
    assert_match(/registerShadcnControllers/, File.read(Rails.root.join("app/javascript/application.js")))
    assert_match(/builder: Shadcn::FormBuilder/, File.read(Rails.root.join("app/views/app/settings.html.erb")))
    assert_match(/Shadcn::DataTable\.new/, File.read(Rails.root.join("app/views/app/dashboard.html.erb")))
    assert_match(/Shadcn::Chart\.new/, File.read(Rails.root.join("app/views/app/dashboard.html.erb")))
  end
end
