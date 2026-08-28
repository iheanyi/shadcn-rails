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
      assert_includes content, '@import "../builds/tailwind/shadcn_rails";'
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

  def test_tailwind_v4_engine_entrypoint_imports_shadcn_styles
    engine_file = File.expand_path("../../../app/assets/tailwind/shadcn_rails/engine.css", __dir__)
    content = File.read(engine_file)

    assert_includes content, '@import "../../stylesheets/shadcn/base.css";'
    assert_includes content, '@import "../../stylesheets/shadcn/components.css";'
    assert_includes content, '@import "../../stylesheets/shadcn/tailwind-v4.css";'
  end

  def test_tailwind_v4_theme_file_maps_dialog_motion_utilities
    theme_file = File.expand_path("../../../app/assets/stylesheets/shadcn/tailwind-v4.css", __dir__)
    content = File.read(theme_file)

    assert_includes content, "--animate-in: enter 150ms ease-out both;"
    assert_includes content, "--animate-out: exit 150ms ease-in both;"
    assert_includes content, "@keyframes enter"
    assert_includes content, "@keyframes zoom-in-95"
    assert_includes content, ".shadcn-dialog-content[data-state=\"open\"]"
    assert_includes content, "animation: enter 200ms cubic-bezier(0.16, 1, 0.3, 1) both;"
    assert_includes content, ".shadcn-toast[data-state=\"open\"]"
    assert_includes content, "--tw-enter-translate-x: 100%;"
    assert_includes content, ".shadcn-tooltip[data-state=\"open\"]"
    assert_includes content, "animation: fade-in 150ms ease-out both;"
    assert_includes content, "@utility fade-in-0"
    assert_includes content, "@utility zoom-in-95"
    assert_includes content, "@utility slide-in-from-left-*"
    assert_includes content, "@utility slide-out-to-left-*"
  end

  def test_component_fallback_file_defines_dialog_motion_keyframes
    components_file = File.expand_path("../../../app/assets/stylesheets/shadcn/components.css", __dir__)
    content = File.read(components_file)

    assert_includes content, "@keyframes fade-in"
    assert_includes content, "@keyframes zoom-in-95"
    assert_includes content, ".shadcn-dialog-content[data-state=\"open\"]"
    assert_includes content, "animation: fade-in 200ms cubic-bezier(0.16, 1, 0.3, 1), zoom-in-95 200ms cubic-bezier(0.16, 1, 0.3, 1);"
  end

  private

  def write_file(path, content)
    full_path = File.join(destination_root, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end
