# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  class JsGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates/javascript", __dir__)

    class_option :path, type: :string, default: nil, desc: "Path to install controllers"
    class_option :bundler, type: :string, default: "auto",
                 desc: "JS bundler: auto, importmap, esbuild, webpack, vite"

    desc "Install Stimulus controllers for shadcn interactive components"

    CONTROLLERS = %w[dialog dropdown tabs tooltip].freeze

    def detect_bundler
      @bundler = options[:bundler]
      if @bundler == "auto"
        @bundler = detect_js_bundler
        say_status :info, "Detected bundler: #{@bundler}", :blue
      end
    end

    def set_controller_path
      @controller_path = options[:path] || default_controller_path
    end

    def create_controllers_directory
      empty_directory @controller_path unless File.directory?(@controller_path)
    end

    def install_controllers
      CONTROLLERS.each do |controller|
        template "controllers/#{controller}_controller.js.tt",
                 File.join(@controller_path, "#{controller}_controller.js")
        say_status :create, "#{@controller_path}/#{controller}_controller.js", :green
      end
    end

    def install_index_file
      return if @bundler == "importmap"

      template "index.js.tt", File.join(@controller_path, "..", "shadcn", "index.js")
      say_status :create, "app/javascript/shadcn/index.js", :green
    end

    def update_importmap
      return unless @bundler == "importmap"
      return unless File.exist?("config/importmap.rb")

      append_to_file "config/importmap.rb" do
        <<~RUBY

          # shadcn-rails controllers
          pin_all_from "app/javascript/controllers", under: "controllers"
        RUBY
      end
      say_status :append, "config/importmap.rb", :green
    end

    def display_completion_message
      say ""
      say "✅ Stimulus controllers installed!", :green
      say ""

      case @bundler
      when "importmap"
        say "Controllers are ready to use with Importmap.", :cyan
        say "Make sure your application.js imports the controllers.", :cyan
      when "esbuild", "webpack", "rollup"
        say "Controllers installed to #{@controller_path}", :cyan
        say "They should be auto-loaded if you're using @hotwired/stimulus-loading.", :cyan
        say ""
        say "Or manually register them in your application.js:", :yellow
        say '  import { registerControllers } from "./shadcn"'
        say "  registerControllers(application)"
      when "vite"
        say "Controllers installed. Import them in your entrypoint:", :cyan
        say '  import { registerControllers } from "@/shadcn"'
        say "  registerControllers(application)"
      end

      say ""
    end

    private

    def detect_js_bundler
      if File.exist?("config/importmap.rb")
        "importmap"
      elsif File.exist?("vite.config.ts") || File.exist?("vite.config.js")
        "vite"
      elsif File.exist?("esbuild.config.js") || (File.exist?("package.json") && package_json_includes?("esbuild"))
        "esbuild"
      elsif File.exist?("webpack.config.js") || (File.exist?("package.json") && package_json_includes?("webpack"))
        "webpack"
      else
        "importmap" # Default fallback
      end
    end

    def package_json_includes?(package)
      return false unless File.exist?("package.json")

      content = File.read("package.json")
      content.include?(package)
    end

    def default_controller_path
      case @bundler
      when "vite"
        "app/frontend/controllers"
      else
        "app/javascript/controllers"
      end
    end
  end
end
