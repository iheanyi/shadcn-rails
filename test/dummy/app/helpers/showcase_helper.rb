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
      render(
        "docs/code_example",
        language: "erb",
        code: showcase_example_source(component_name, preview_class, example),
        title: "#{component_name}/#{example}"
      )
    ])
  end

  private

  def showcase_example_source(component_name, preview_class, example)
    example_paths = [example.to_s, example.to_s.tr("_", "-")].map do |example_name|
      Rails.root.join("app/code_examples/#{component_name}/#{example_name}.txt")
    end
    example_path = example_paths.find { |path| File.exist?(path) }

    return File.read(example_path) if example_path

    raise ArgumentError,
      "Missing code example for #{preview_class.name}##{example}: expected #{example_paths.map { |path| path.relative_path_from(Rails.root) }.join(' or ')}"
  end

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
end
