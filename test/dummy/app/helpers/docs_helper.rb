# frozen_string_literal: true

module DocsHelper
  # Load a code example from a file
  # Usage: code_example("button/usage") loads app/code_examples/button/usage.txt
  def code_example_file(path)
    file_path = Rails.root.join("app/code_examples/#{path}.txt")
    if File.exist?(file_path)
      File.read(file_path).strip
    else
      "# Code example not found: #{path}"
    end
  end

  # Shorthand helper for erb code examples
  # Automatically sets language to "erb"
  def erb_example(path, **options)
    render "docs/code_example", language: "erb", code: code_example_file(path), **options
  end

  # Shorthand helper for ruby code examples
  def ruby_example(path, **options)
    render "docs/code_example", language: "ruby", code: code_example_file(path), **options
  end

  # Shorthand helper for bash code examples
  def bash_example(code, **options)
    render "docs/code_example", language: "bash", code: code, **options
  end
end
