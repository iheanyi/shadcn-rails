# frozen_string_literal: true

require "test_helper"

class ShadcnConfigurationTest < ActiveSupport::TestCase
  teardown do
    Shadcn::Rails.reset_configuration!
  end

  def test_theme_css_reads_configured_theme_from_css_source
    Shadcn::Rails.configure do |config|
      config.theme = :slate
    end

    css = Shadcn::Rails.theme_css

    assert_includes css, "--foreground: 222.2 84% 4.9%;"
    refute_includes css, "--foreground: 0 0% 3.9%;"
  end

  def test_theme_css_applies_radius_override
    Shadcn::Rails.configure do |config|
      config.theme = :slate
      config.radius = "0.75rem"
    end

    assert_includes Shadcn::Rails.theme_css, "--radius: 0.75rem;"
  end

  def test_base_color_is_deprecated_theme_alias
    Shadcn::Rails.configure do |config|
      config.base_color = "slate"
    end

    assert_equal :slate, Shadcn::Rails.configuration.theme
    assert_includes Shadcn::Rails.theme_css, "--foreground: 222.2 84% 4.9%;"
  end

  def test_dark_mode_media_rewrites_dark_selector
    Shadcn::Rails.configure do |config|
      config.theme = :slate
      config.dark_mode = :media
    end

    css = Shadcn::Rails.theme_css

    assert_includes css, "@media (prefers-color-scheme: dark)"
    assert_includes css, ":root {\n    --background: 222.2 84% 4.9%;"
    refute_includes css, ".dark {"
  end

  def test_dark_mode_both_keeps_class_and_media
    Shadcn::Rails.configure do |config|
      config.theme = :slate
      config.dark_mode = :both
    end

    css = Shadcn::Rails.theme_css

    assert_includes css, "@media (prefers-color-scheme: dark)"
    assert_includes css, ".dark {"
  end

  def test_shadcn_theme_helper_outputs_configured_style_tag
    Shadcn::Rails.configure do |config|
      config.theme = :slate
      config.radius = "1rem"
    end

    helper = ActionView::Base.empty
    helper.extend Shadcn::Rails::Helpers::ComponentHelper
    html = helper.shadcn_theme

    assert_includes html, "<style"
    assert_includes html, "data-shadcn-theme"
    assert_includes html, "--foreground: 222.2 84% 4.9%;"
    assert_includes html, "--radius: 1rem;"
  end
end
