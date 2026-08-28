# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/shadcn/install/install_generator"

class ShadcnInstallGeneratorTest < Rails::Generators::TestCase
  tests Shadcn::Generators::InstallGenerator
  destination File.expand_path("../../tmp/generators/shadcn_install", __dir__)

  setup :prepare_destination

  def test_installs_into_tailwind_v4_stylesheet_and_importmap_app
    write_file "app/assets/tailwind/application.css", <<~CSS
      @import "tailwindcss";
    CSS
    write_file "config/importmap.rb", <<~RUBY
      pin "application"
    RUBY
    write_file "app/javascript/controllers/application.js", <<~JS
      import { Application } from "@hotwired/stimulus"
      const application = Application.start()
    JS

    run_generator

    assert_file "config/initializers/shadcn.rb"
    assert_no_file "config/shadcn.yml"

    assert_file "app/assets/tailwind/application.css" do |content|
      assert_includes content, '@import "tailwindcss";'
      assert_includes content, '@import "shadcn/base";'
      assert_includes content, '@import "shadcn/components";'
      assert_includes content, '@import "shadcn/tailwind-v4";'
    end

    assert_file "config/importmap.rb" do |content|
      assert_includes content, 'pin "shadcn", to: "shadcn/index.js"'
      assert_includes content, 'pin "@floating-ui/dom"'
      assert_includes content, 'pin "stimulus-use"'
    end

    assert_file "app/javascript/controllers/application.js" do |content|
      assert_includes content, 'import { registerShadcnControllers } from "shadcn"'
      assert_includes content, "registerShadcnControllers(application)"
    end
  end

  def test_installs_into_tailwind_v3_stylesheet
    write_file "app/assets/stylesheets/application.tailwind.css", <<~CSS
      @tailwind base;
      @tailwind components;
      @tailwind utilities;
    CSS

    run_generator

    assert_file "app/assets/stylesheets/application.tailwind.css" do |content|
      assert_operator content.index('@import "shadcn/base";'), :<, content.index("@tailwind base;")
      assert_operator content.index('@import "shadcn/components";'), :<, content.index("@tailwind base;")
      refute_includes content, "shadcn/tailwind-v4"
    end
  end

  def test_tailwind_v4_theme_file_maps_primary_color
    theme_file = File.expand_path("../../../app/assets/stylesheets/shadcn/tailwind-v4.css", __dir__)

    assert_includes File.read(theme_file), '@source "../../../components/shadcn";'
    assert_includes File.read(theme_file), "--color-primary: hsl(var(--primary));"
  end

  private

  def write_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
