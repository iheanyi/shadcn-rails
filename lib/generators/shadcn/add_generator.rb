# frozen_string_literal: true

require "rails/generators"

module Shadcn
  class AddGenerator < ::Rails::Generators::Base
    # Alias for component generator - shadcn/ui uses "add" command
    # This allows: rails g shadcn:add button card

    desc "Alias for shadcn:component - Add shadcn UI components to your application"

    def run_component_generator
      args = ARGV.drop(1) # Remove the generator name
      generate "shadcn:component", *args
    end
  end
end
