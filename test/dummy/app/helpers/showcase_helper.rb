# frozen_string_literal: true

require "ripper"

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
        title: "#{preview_class.name}##{example}"
      )
    ])
  end

  private

  def showcase_example_source(component_name, preview_class, example)
    [example.to_s, example.to_s.tr("_", "-")].each do |example_name|
      example_path = Rails.root.join("app/code_examples/#{component_name}/#{example_name}.txt")
      return File.read(example_path) if File.exist?(example_path)
    end

    erb_preview_method_source(preview_class, example)
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

  def preview_method_source(preview_class, example)
    file, line = preview_class.instance_method(example).source_location
    return "# Source unavailable" unless file && line

    source = File.read(file)
    source_lines = source.lines
    end_line = ruby_method_end_line(source, example, line)
    return "# Source unavailable" unless end_line

    method_lines = source_lines[(line - 1)..(end_line - 1)]
    strip_preview_source_indentation(method_lines.join)
  end

  def erb_preview_method_source(preview_class, example)
    source = preview_method_source(preview_class, example)
    lines = source.lines
    lines = lines[1..-2] if lines.first&.match?(/\A\s*def\b/) && lines.last&.match?(/\A\s*end\s*\z/)

    strip_preview_source_indentation(lines.join)
      .sub(/\Arender\(/, "<%= render(")
      .sub(/\Arender\b/, "<%= render")
      .then { |code| code.start_with?("<%=") ? "#{code.chomp} %>\n" : code }
  end

  def ruby_method_end_line(source, method_name, start_line)
    ast_end_line = ruby_ast_method_end_line(source, method_name, start_line)
    return ast_end_line if ast_end_line

    tokens = Ripper.lex(source)
    start_index = tokens.index do |position, token_type, token, _state|
      position.first == start_line && token_type == :on_kw && token == "def"
    end
    return unless start_index

    depth = 0

    tokens[start_index..].each_with_index do |(position, token_type, token, state), offset|
      next unless token_type == :on_kw
      next if ruby_symbol_keyword?(tokens, start_index + offset)
      next if ruby_modifier_keyword?(token, state)

      if ruby_opening_keyword?(token)
        depth += 1
      elsif token == "end"
        depth -= 1
        return position.first if depth.zero?
      end
    end

    nil
  end

  def ruby_ast_method_end_line(source, method_name, start_line)
    return unless defined?(RubyVM::AbstractSyntaxTree)

    method_node = ruby_ast_method_node(RubyVM::AbstractSyntaxTree.parse(source), method_name.to_sym, start_line)
    method_node&.last_lineno
  rescue SyntaxError
    nil
  end

  def ruby_ast_method_node(node, method_name, start_line)
    return unless node.respond_to?(:type)

    if %i[DEFN DEFS].include?(node.type) && node.first_lineno == start_line && node.children.include?(method_name)
      return node
    end

    node.children.filter_map { |child| ruby_ast_method_node(child, method_name, start_line) }.first
  end

  def ruby_opening_keyword?(token)
    %w[begin case class def do for if module unless until while].include?(token)
  end

  def ruby_symbol_keyword?(tokens, index)
    index.positive? && tokens[index - 1][1] == :on_symbeg
  end

  def ruby_modifier_keyword?(token, state)
    %w[if unless].include?(token) && state.to_s.include?("LABEL")
  end

  def strip_preview_source_indentation(source)
    lines = source.lines
    indent = lines.reject { |line| line.strip.empty? }.map { |line| line[/\A */].size }.min || 0
    lines.map { |line| line.sub(/\A {0,#{indent}}/, "") }.join.strip
  end
end
