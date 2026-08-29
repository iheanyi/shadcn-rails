# frozen_string_literal: true

module DocsHelper
  # Shorthand helper for bash code examples
  def bash_example(code, **options)
    render "docs/code_example", language: "bash", code: code, **options
  end
end
