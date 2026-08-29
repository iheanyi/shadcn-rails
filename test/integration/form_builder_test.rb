# frozen_string_literal: true

require "test_helper"

class FormBuilderTest < ActionDispatch::IntegrationTest
  test "renders shadcn components with Rails field names and ids" do
    get "/form_builder_test/new"

    assert_response :success
    assert_select "form[enctype='multipart/form-data']"
    assert_select "label[for='contact_email']", text: "Email"
    assert_select "label.sr-only[for='contact_email']", text: "Email"
    assert_select "input[type='email'][name='contact[email]'][id='contact_email'][placeholder='you@example.com'][required]"
    assert_select "textarea[name='contact[notes]'][id='contact_notes'][rows='4'][autocomplete='off']", text: "Initial notes"
    assert_select "textarea[name='contact[notes]'][id='contact_notes'][rows='2']", text: "Initial notes"
    assert_select "input[type='hidden'][name='contact[subscribed]'][value='0']"
    assert_select "input[type='checkbox'][name='contact[subscribed]'][id='contact_subscribed'][value='1'][checked]"
    assert_select "input[type='checkbox'][name='contact[subscribed]'][id='contact_subscribed_alias'][value='1'][checked]"
    assert_select "input[type='checkbox'][name='contact[disabled_checkbox]'][id='contact_disabled_checkbox'][disabled]"
    assert_select "input[type='hidden'][name='contact[disabled_checkbox]']", 0
    assert_select "input[type='hidden'][name='contact[notifications]'][value='0']"
    assert_select "input[type='checkbox'][name='contact[notifications]'][id='contact_notifications'][value='1'][checked]"
    assert_select "input[type='checkbox'][name='contact[disabled_switch]'][id='contact_disabled_switch'][disabled]"
    assert_select "input[type='hidden'][name='contact[disabled_switch]']", 0
    assert_select "input[type='hidden'][name='contact[source]'][id='contact_source'][value='website']", visible: :all
    assert_select "input[type='file'][name='contact[attachments][]'][id='contact_attachments'][multiple]"
    assert_select "input[type='date'][name='contact[birthdate]'][id='contact_birthdate'][value='2026-08-29']"
    assert_select "input[type='datetime-local'][name='contact[meeting_at]'][id='contact_meeting_at'][value='2026-08-29T14:30:15']"
    assert_select "input[type='time'][name='contact[follow_up_time]'][id='contact_follow_up_time'][value='09:05:06']"
    assert_select "input[type='month'][name='contact[billing_month]'][id='contact_billing_month'][value='2026-08']"
    assert_select "input[type='week'][name='contact[signup_week]'][id='contact_signup_week'][value='2026-W35']"
    assert_select "input[type='range'][name='contact[rating]'][id='contact_rating'][value='7.0'][min='0.0'][max='10.0'][step='1.0']"
    assert_select "input[type='range'][name='contact[budget]'][id='contact_budget'][value='50.0'][min='0.0'][max='100.0'][step='5.0']"
    assert_select "div[data-controller='shadcn--toggle-group'][data-shadcn--toggle-group-type-value='multiple']"
    assert_select "input[type='hidden'][name='contact[tags]'][value='vip']", visible: :all
    assert_select "button[data-value='vip'][data-state='on']", text: "VIP"
    assert_select "div[role='radiogroup'][data-controller='shadcn--radio-group'][data-shadcn--radio-group-name-value='contact[contact_method]']"
    assert_select "input[type='radio'][name='contact[contact_method]'][id='contact_contact_method_email'][value='email'][checked]"
    assert_select "input[type='radio'][name='contact[status]'][id='contact_status_customer'][value='customer'][checked]"
    assert_select "input[type='hidden'][name='contact[channels][]'][value='']", visible: :all
    assert_select "input[type='checkbox'][name='contact[channels][]'][id='contact_channels_email'][value='email'][checked]"
    assert_select "input[type='radio'][name='contact[status]'][id='contact_status_lead'][value='lead']"
    assert_select "input[type='radio'][name='contact[status]'][id='contact_status_customer'][value='customer'][checked]"
    assert_select "select.status-select[name='contact[status]'][id='contact_status'][required]"
    assert_select "select option[value='customer'][selected]", text: "customer"
    assert_select "button.submit-extra[type='submit'][name='commit'][value='Save']", text: "Save"
    assert_select "button[type='submit'][name='button'][value='Create']", text: "Create"
    assert_select "button.button-extra[type='submit'][name='button']", text: "Button"
  end

  test "toggle_group multiple redisplays comma separated posted values as pressed" do
    get "/form_builder_test/new?comma_tags=1"

    assert_response :success
    assert_select "input[type='hidden'][name='contact[tags]'][value='vip,newsletter']", visible: :all
    assert_select "button[data-value='vip'][data-state='on']", text: "VIP"
    assert_select "button[data-value='newsletter'][data-state='on']", text: "Newsletter"
  end

  test "renders nested fields_for names and ids" do
    get "/form_builder_test/new"

    assert_response :success
    assert_select "label[for='contact_addresses_attributes_0_city']", text: "City"
    assert_select "input[type='text'][name='contact[addresses_attributes][0][city]'][id='contact_addresses_attributes_0_city'][value='Lagos']"
  end

  test "posts vanilla Rails params including unchecked checkbox hidden values" do
    post "/form_builder_test", params: {
      contact: {
        email: "new@example.com",
        notes: "Submitted notes",
        subscribed: "0",
        notifications: "0",
        status: "lead",
        rating: "8",
        budget: "75",
        tags: "vip,newsletter",
        contact_method: "phone",
        channels: ["email", "sms"],
        source: "campaign",
        addresses_attributes: {
          "0" => { city: "Ibadan" }
        }
      }
    }

    assert_response :success
    parsed = JSON.parse(response.body)

    assert_equal "new@example.com", parsed["email"]
    assert_equal "Submitted notes", parsed["notes"]
    assert_equal "0", parsed["subscribed"]
    assert_equal "0", parsed["notifications"]
    assert_equal "lead", parsed["status"]
    assert_equal "8", parsed["rating"]
    assert_equal "75", parsed["budget"]
    assert_equal "vip,newsletter", parsed["tags"]
    assert_equal "phone", parsed["contact_method"]
    assert_equal ["email", "sms"], parsed["channels"]
    assert_equal "campaign", parsed["source"]
    assert_equal "Ibadan", parsed.dig("addresses_attributes", "0", "city")
  end

  test "marks invalid controls and renders field error text" do
    get "/form_builder_test/new?invalid=1"

    assert_response :success
    assert_select "input[name='contact[email]'][aria-invalid='true'][aria-describedby='contact_email_error']"
    assert_select "select.status-select.border-destructive[name='contact[status]'][aria-invalid='true'][aria-describedby='contact_status_error']"
    assert_select "p#contact_email_error[role='alert']", text: "Email can't be blank"
  end

  test "form select uses native select instead of overlay listbox markup" do
    get "/form_builder_test/new"

    assert_response :success
    assert_select "select[name='contact[status]']", 1
    assert_select "[role='listbox']", 0
    assert_select "button[role='combobox']", 0
  end

  test "form_for renders shadcn components with Rails field names and ids" do
    get "/form_builder_test/form_for"

    assert_response :success
    assert_select "form[action='/form_builder_test'][method='post'][enctype='multipart/form-data']"
    assert_select "label[for='contact_email']", text: "Email"
    assert_select "input[type='email'][name='contact[email]'][id='contact_email'][value='legacy@example.com']"
    assert_select "input[type='hidden'][name='contact[subscribed]'][value='0']"
    assert_select "input[type='checkbox'][name='contact[subscribed]'][id='contact_subscribed'][value='1']"
    assert_select "select.legacy-status-select[name='contact[status]'][id='contact_status']"
    assert_select "select option[value='lead'][selected]", text: "lead"
    assert_select "button[type='submit'][name='commit'][value='Save']", text: "Save"
  end

  test "form_for renders nested fields_for names and ids" do
    get "/form_builder_test/form_for"

    assert_response :success
    assert_select "label[for='contact_addresses_attributes_0_city']", text: "City"
    assert_select "input[type='text'][name='contact[addresses_attributes][0][city]'][id='contact_addresses_attributes_0_city'][value='Enugu']"
    assert_select "input[type='file'][name='contact[addresses_attributes][0][photo]'][id='contact_addresses_attributes_0_photo']"
  end

  test "form_for submitted params use vanilla Rails contact structure" do
    post "/form_builder_test", params: {
      contact: {
        email: "legacy-submit@example.com",
        subscribed: "0",
        status: "archived",
        addresses_attributes: {
          "0" => { city: "Aba" }
        }
      }
    }

    assert_response :success
    parsed = JSON.parse(response.body)

    assert_equal "legacy-submit@example.com", parsed["email"]
    assert_equal "0", parsed["subscribed"]
    assert_equal "archived", parsed["status"]
    assert_equal "Aba", parsed.dig("addresses_attributes", "0", "city")
  end

  test "docs form page renders live form_with and form_for demos" do
    get "/docs/components/form"

    assert_response :success
    assert_select "h2", text: "form_with"
    assert_select "h2", text: "form_for"
    assert_select "form", minimum: 2
    assert_select "input[type='email'][name='contact[email]'][id='contact_email'][value='person@example.com']", 2
    assert_select "textarea[name='contact[notes]'][id='contact_notes']", text: "Interested in a follow-up next week.", count: 2
    assert_select "input[type='hidden'][name='contact[subscribed]'][value='0']", 2
    assert_select "input[type='checkbox'][name='contact[subscribed]'][id='contact_subscribed'][value='1'][checked]", 2
    assert_select "select[name='contact[status]'][id='contact_status']", 2
    assert_select "input[type='range'][name='contact[rating]'][id='contact_rating'][value='7.0']", 1
    assert_select "div[data-controller='shadcn--toggle-group'] input[type='hidden'][name='contact[tags]'][value='vip']", 1
    assert_select "div[role='radiogroup'][data-controller='shadcn--radio-group'] input[name='contact[contact_method]'][value='email'][checked]", 1
    assert_select "input[type='checkbox'][name='contact[channels][]'][id='contact_channels_email'][value='email'][checked]", 1
    assert_select "button[type='submit'][name='commit'][value='Save']", text: "Save", count: 2
    assert_includes response.body, "form_with model: @contact"
    assert_includes response.body, "form_for @contact"
    assert_includes response.body, "f.slider :rating"
    assert_includes response.body, "f.toggle_group :tags"
    assert_includes response.body, "f.radio_group :contact_method"
  end
end
