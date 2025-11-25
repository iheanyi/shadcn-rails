# frozen_string_literal: true

require "test_helper"
require "generators/shadcn/js_generator"
require "rails/generators/test_case"

class JsGeneratorTest < Rails::Generators::TestCase
  tests Shadcn::JsGenerator
  destination File.expand_path("../../tmp", __dir__)

  setup do
    prepare_destination
  end

  test "generates all stimulus controllers" do
    run_generator ["--bundler=importmap"]

    assert_file "app/javascript/controllers/dialog_controller.js" do |content|
      assert_match(/export default class extends Controller/, content)
      assert_match(/open\(\)/, content)
      assert_match(/close\(\)/, content)
    end

    assert_file "app/javascript/controllers/dropdown_controller.js" do |content|
      assert_match(/export default class extends Controller/, content)
      assert_match(/toggle\(\)/, content)
    end

    assert_file "app/javascript/controllers/tabs_controller.js" do |content|
      assert_match(/export default class extends Controller/, content)
      assert_match(/select\(/, content)
    end

    assert_file "app/javascript/controllers/tooltip_controller.js" do |content|
      assert_match(/export default class extends Controller/, content)
      assert_match(/show\(\)/, content)
      assert_match(/hide\(\)/, content)
    end
  end

  test "generates index.js for esbuild bundler" do
    run_generator ["--bundler=esbuild"]

    assert_file "app/javascript/shadcn/index.js" do |content|
      assert_match(/import DialogController/, content)
      assert_match(/export function registerControllers/, content)
    end
  end

  test "skips index.js for importmap bundler" do
    run_generator ["--bundler=importmap"]

    assert_no_file "app/javascript/shadcn/index.js"
  end

  test "uses custom path when specified" do
    run_generator ["--path=app/frontend/controllers", "--bundler=vite"]

    assert_file "app/frontend/controllers/dialog_controller.js"
    assert_file "app/frontend/controllers/dropdown_controller.js"
  end

  test "updates importmap.rb when present" do
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write(File.join(destination_root, "config/importmap.rb"), "# Importmap\n")

    run_generator ["--bundler=importmap"]

    assert_file "config/importmap.rb" do |content|
      assert_match(/shadcn-rails controllers/, content)
      assert_match(/pin_all_from/, content)
    end
  end
end
