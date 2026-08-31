# frozen_string_literal: true

require "test_helper"

class ShadcnClassMergerTest < ActiveSupport::TestCase
  teardown do
    Shadcn::Rails.reset_configuration!
  end

  def test_padding_shorthand_overrides_axis_padding
    classes = Shadcn::Rails.cn("px-4 py-2 p-0").split

    assert_includes classes, "p-0"
    refute_includes classes, "px-4"
    refute_includes classes, "py-2"
  end

  def test_size_overrides_width_and_height
    classes = Shadcn::Rails.cn("h-9 w-4 size-8").split

    assert_includes classes, "size-8"
    refute_includes classes, "h-9"
    refute_includes classes, "w-4"
  end

  def test_flex_basis_conflicts_are_merged
    classes = Shadcn::Rails.cn("basis-full basis-1/3").split

    assert_includes classes, "basis-1/3"
    refute_includes classes, "basis-full"
  end

  def test_background_color_conflicts_are_merged
    classes = Shadcn::Rails.cn("bg-primary bg-red-500").split

    assert_includes classes, "bg-red-500"
    refute_includes classes, "bg-primary"
  end

  def test_unknown_hook_classes_survive
    classes = Shadcn::Rails.cn("flex shadcn-select-content p-1").split

    assert_includes classes, "flex"
    assert_includes classes, "shadcn-select-content"
    assert_includes classes, "p-1"
  end

  def test_merger_rebuilds_when_tailwind_prefix_changes
    Shadcn::Rails.configure do |config|
      config.tailwind_prefix = "tw-"
    end

    tw_classes = Shadcn::Rails::ClassMerger.merge("tw-px-4 tw-p-0").split
    assert_includes tw_classes, "tw-p-0"
    refute_includes tw_classes, "tw-px-4"

    Shadcn::Rails.configure do |config|
      config.tailwind_prefix = "ui-"
    end

    ui_classes = Shadcn::Rails::ClassMerger.merge("ui-px-4 ui-p-0").split
    assert_includes ui_classes, "ui-p-0"
    refute_includes ui_classes, "ui-px-4"
  end

  def test_prefixed_variant_classes_are_merged
    Shadcn::Rails.configure do |config|
      config.tailwind_prefix = "tw-"
    end

    classes = Shadcn::Rails::ClassMerger.merge("hover:tw-px-4 hover:tw-p-0").split
    assert_includes classes, "hover:tw-p-0"
    refute_includes classes, "hover:tw-px-4"
  end

  def test_unprefixed_negative_and_important_classes_are_preserved_with_tailwind_prefix
    Shadcn::Rails.configure do |config|
      config.tailwind_prefix = "tw-"
    end

    classes = Shadcn::Rails::ClassMerger.merge("-mt-4 !hidden hover:-mt-2").split
    assert_includes classes, "-mt-4"
    assert_includes classes, "!hidden"
    assert_includes classes, "hover:-mt-2"
  end

  def test_focus_visible_ring_width_can_override_arbitrary_ring_width
    classes = Shadcn::Rails::ClassMerger.merge(
      "focus-visible:ring-ring/50 focus-visible:ring-[3px]",
      "focus-visible:ring-0"
    ).split

    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "focus-visible:ring-0"
    refute_includes classes, "focus-visible:ring-[3px]"
  end

  def test_focus_within_ring_width_preserves_ring_color
    classes = Shadcn::Rails::ClassMerger.merge(
      "focus-within:ring-ring/50 focus-within:ring-[3px]",
      "focus-within:ring-0"
    ).split

    assert_includes classes, "focus-within:ring-ring/50"
    assert_includes classes, "focus-within:ring-0"
    refute_includes classes, "focus-within:ring-[3px]"
  end
end
