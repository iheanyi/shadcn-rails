# frozen_string_literal: true

module ShowcaseHelper
  def showcase(component_name, example_name = :default, title: nil, description: nil, class_name: "")
    preview_class = preview_class_for(component_name)
    example = example_name.to_sym

    unless preview_class.public_instance_methods(false).include?(example)
      raise ArgumentError, "#{preview_class.name} does not define ##{example}"
    end

    safe_join([
      render("docs/demo_card", title: title, description: description, class_name: class_name) do
        render_preview_example(preview_class, example)
      end,
      render("docs/code_example", language: "ruby", code: preview_method_source(preview_class, example), title: "#{preview_class.name}##{example}")
    ])
  end

  private

  def preview_class_for(component_name)
    normalized = component_name.to_s.tr("-", "_")
    "#{normalized.camelize}ComponentPreview".safe_constantize ||
      raise(ArgumentError, "Preview not found for #{component_name}")
  end

  def render_preview_example(preview_class, example)
    return render_preview(example, from: preview_class) if respond_to?(:render_preview)

    preview_result = preview_class.new.public_send(example)
    render_preview_result(preview_result)
  end

  def render_preview_result(preview_result)
    return preview_result if preview_result.is_a?(String)

    if preview_result.is_a?(Hash) && preview_result[:component]
      component = preview_result[:component]
      args = preview_result.fetch(:args, {})
      block = preview_result[:block]
      return args.is_a?(Hash) ? render(component, **args, &block) : render(component, *args, &block)
    end

    render(preview_result)
  end

  def preview_method_source(preview_class, example)
    file, line = preview_class.instance_method(example).source_location
    return "# Source unavailable" unless file && line

    source_lines = File.readlines(file)
    method_lines = extract_method_lines(source_lines, line - 1)
    strip_preview_source_indentation(method_lines.join)
  end

  def extract_method_lines(source_lines, start_index)
    lines = []
    depth = 0

    source_lines[start_index..].each do |line|
      lines << line
      code = line.sub(/#.*/, "")
      depth += code.scan(/\b(class|module|def|if|unless|case|begin|while|until|for)\b|(^|[^:])\bdo\b/).length
      depth -= code.scan(/\bend\b/).length
      break if depth <= 0 && lines.any?
    end

    lines
  end

  def strip_preview_source_indentation(source)
    lines = source.lines
    indent = lines.reject { |line| line.strip.empty? }.map { |line| line[/\A */].size }.min || 0
    lines.map { |line| line.sub(/\A {0,#{indent}}/, "") }.join.strip
  end
end
