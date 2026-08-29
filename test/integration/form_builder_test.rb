# frozen_string_literal: true

require "test_helper"

class FormBuilderTest < ActionDispatch::IntegrationTest
  test "renders shadcn components with Rails field names and ids" do
    get "/form_builder_test/new"

    assert_response :success
    assert_select "label[for='contact_email']", text: "Email"
    assert_select "input[type='email'][name='contact[email]'][id='contact_email'][placeholder='you@example.com'][required]"
    assert_select "textarea[name='contact[notes]'][id='contact_notes'][rows='4'][autocomplete='off']", text: "Initial notes"
    assert_select "input[type='hidden'][name='contact[subscribed]'][value='0']"
    assert_select "input[type='checkbox'][name='contact[subscribed]'][id='contact_subscribed'][value='1'][checked]"
    assert_select "input[type='hidden'][name='contact[notifications]'][value='0']"
    assert_select "input[type='checkbox'][name='contact[notifications]'][id='contact_notifications'][value='1'][checked]"
    assert_select "input[type='radio'][name='contact[status]'][id='contact_status_lead'][value='lead']"
    assert_select "input[type='radio'][name='contact[status]'][id='contact_status_customer'][value='customer'][checked]"
    assert_select "select.status-select[name='contact[status]'][id='contact_status'][required]"
    assert_select "select option[value='customer'][selected]", text: "customer"
    assert_select "button[type='submit'][name='commit'][value='Save']", text: "Save"
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
    assert_equal "Ibadan", parsed.dig("addresses_attributes", "0", "city")
  end

  test "marks invalid controls and renders field error text" do
    get "/form_builder_test/new?invalid=1"

    assert_response :success
    assert_select "input[name='contact[email]'][aria-invalid='true'][aria-describedby='contact_email_error']"
    assert_select "p#contact_email_error[role='alert']", text: "Email can't be blank"
  end

  test "form select uses native select instead of overlay listbox markup" do
    get "/form_builder_test/new"

    assert_response :success
    assert_select "select[name='contact[status]']", 1
    assert_select "[role='listbox']", 0
    assert_select "button[role='combobox']", 0
  end
end
