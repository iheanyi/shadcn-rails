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

    assert_includes rendered, ">name<"
    assert_match(/>\s*String\s*</, rendered)
    assert_match(/>\s*nil\s*</, rendered)
    assert_match(/>\s*false\s*</, rendered)
    refute_includes rendered, ">API Reference<"
  end
end
