# frozen_string_literal: true

require "test_helper"

class DummyDocsCodeExamplesTest < ActionDispatch::IntegrationTest
  def test_file_backed_erb_examples_render_without_template_parse_errors
    {
      "spinner" => "&lt;%= render Shadcn::SpinnerComponent.new %&gt;",
      "typography" => "&lt;%= render Shadcn::TypographyComponent.new(variant: :h1) { &quot;Heading&quot; } %&gt;",
      "kbd" => "&lt;%= render Shadcn::KbdComponent.new { &quot;K&quot; } %&gt;"
    }.each do |slug, expected_code|
      get "/docs/components/#{slug}"

      assert_response :success
      assert_includes response.body, expected_code
    end
  end
end
