# frozen_string_literal: true

require "test_helper"

class DummyDocsPartialsTest < ActionView::TestCase
  def test_props_table_renders_string_key_and_nil_defaults
    render partial: "docs/props_table", locals: {
      title: nil,
      props: [
        { "name" => "name", "type" => "String", "default" => nil, "description" => "Input name attribute" },
        { name: "disabled", type: "Boolean", default: false, description: "Whether disabled" }
      ]
    }

    assert_includes rendered, ">nil<"
    assert_includes rendered, ">false<"
    refute_includes rendered, ">API Reference<"
  end
end
