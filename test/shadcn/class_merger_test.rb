# frozen_string_literal: true

require "test_helper"

class ShadcnClassMergerTest < ActiveSupport::TestCase
  def test_focus_visible_ring_width_can_override_arbitrary_ring_width
    classes = Shadcn::Rails::ClassMerger.merge(
      "focus-visible:ring-ring/50 focus-visible:ring-[3px]",
      "focus-visible:ring-0"
    )

    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "focus-visible:ring-0"
    refute_includes classes, "focus-visible:ring-[3px]"
  end

  def test_focus_within_ring_width_preserves_ring_color
    classes = Shadcn::Rails::ClassMerger.merge(
      "focus-within:ring-ring/50 focus-within:ring-[3px]",
      "focus-within:ring-0"
    )

    assert_includes classes, "focus-within:ring-ring/50"
    assert_includes classes, "focus-within:ring-0"
    refute_includes classes, "focus-within:ring-[3px]"
  end
end
