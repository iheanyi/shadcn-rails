# frozen_string_literal: true

require_relative "lib/shadcn/rails/version"

Gem::Specification.new do |spec|
  spec.name = "shadcn-rails"
  spec.version = Shadcn::Rails::VERSION
  spec.authors = ["Iheanyi Ekechukwu"]
  spec.email = ["iekechukwu@gmail.com"]

  spec.summary = "Beautiful, accessible UI components for Rails using ViewComponents and Stimulus"
  spec.description = "A Rails port of shadcn/ui - a collection of beautifully designed, accessible components built with ViewComponents, Stimulus, and Tailwind CSS. Includes theming support, dark mode, and full component parity with the original library."
  spec.homepage = "https://github.com/iheanyi/shadcn-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/iheanyi/shadcn-rails"
  spec.metadata["changelog_uri"] = "https://github.com/iheanyi/shadcn-rails/blob/main/CHANGELOG.md"

  # Include all files tracked by git, excluding development files
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[test/ spec/ features/ .git .github Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "railties", ">= 7.0"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "stimulus-rails", ">= 1.0"
  spec.add_dependency "turbo-rails", ">= 1.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.6"
  spec.add_development_dependency "capybara", "~> 3.0"
  spec.add_development_dependency "cuprite", "~> 0.15"
  spec.add_development_dependency "lookbook", "~> 2.0"
  spec.add_development_dependency "tailwindcss-rails", "~> 3.0"
end
