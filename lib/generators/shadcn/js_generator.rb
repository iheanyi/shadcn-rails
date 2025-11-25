# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  class JsGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates/javascript", __dir__)

    class_option :path, type: :string, default: "app/javascript/controllers", desc: "Path to install controllers"

    desc "Install Stimulus controllers for shadcn interactive components"

    CONTROLLERS = %w[dialog dropdown tabs tooltip].freeze

    def install_controllers
      CONTROLLERS.each do |controller|
        template "controllers/#{controller}_controller.js.tt",
                 File.join(options[:path], "#{controller}_controller.js")
        say_status :create, "#{options[:path]}/#{controller}_controller.js", :green
      end
    end

    def display_completion_message
      say ""
      say "✅ Stimulus controllers installed!", :green
      say ""
      say "If you're using importmap, add the controllers to your manifest.", :cyan
      say "If you're using esbuild/webpack, they should be auto-loaded by stimulus-loading.", :cyan
      say ""
    end
  end
end
