# frozen_string_literal: true

require "yaml"

module Shadcn
  module Rails
    ComponentUnit = Struct.new(
      :name,
      :ruby_files,
      :templates,
      :controllers,
      :css_sidecars,
      :depends_on,
      keyword_init: true
    ) do
      def paths
        ruby_files + templates + controllers + css_sidecars + depends_on
      end
    end

    module Registry
      module_function

      def fetch(name)
        units.fetch(normalize_name(name))
      rescue KeyError
        raise Shadcn::Rails::Error, "Unknown component: #{name}. Available components: #{keys.join(', ')}"
      end

      def keys
        units.keys
      end

      def key?(name)
        units.key?(normalize_name(name))
      end

      def each(&block)
        units.each_value(&block)
      end

      def gem_path(relative_path)
        File.join(gem_root, relative_path)
      end

      def gem_root
        File.expand_path("../../..", __dir__)
      end

      def normalize_name(name)
        name.to_s.tr("-", "_")
      end

      def units
        @units ||= load_units
      end

      def load_units
        raw_units = YAML.safe_load_file(registry_path, aliases: false)

        raw_units.each_with_object({}) do |(name, attrs), registry|
          registry[name] = ComponentUnit.new(
            name: attrs.fetch("name"),
            ruby_files: attrs.fetch("ruby_files", []),
            templates: attrs.fetch("templates", []),
            controllers: attrs.fetch("controllers", []),
            css_sidecars: attrs.fetch("css_sidecars", []),
            depends_on: attrs.fetch("depends_on", [])
          )
        end
      end

      def registry_path
        File.expand_path("registry.yml", __dir__)
      end
    end
  end
end
