# frozen_string_literal: true

require "test_helper"

class Shadcn::Rails::ViewHelpersTest < ActiveSupport::TestCase
  setup do
    @helper_class = Class.new do
      include Shadcn::Rails::ViewHelpers
    end
    @helper = @helper_class.new
  end

  test "cn joins multiple classes" do
    result = @helper.cn("class1", "class2", "class3")
    assert_includes result, "class1"
    assert_includes result, "class2"
    assert_includes result, "class3"
  end

  test "cn handles nil values" do
    result = @helper.cn("class1", nil, "class2")
    assert_includes result, "class1"
    assert_includes result, "class2"
    refute_includes result, "nil"
  end

  test "cn handles arrays of classes" do
    result = @helper.cn(["class1", "class2"], "class3")
    assert_includes result, "class1"
    assert_includes result, "class2"
    assert_includes result, "class3"
  end

  test "cn removes duplicate classes" do
    result = @helper.cn("class1", "class1", "class2")
    assert_equal 1, result.split.count { |c| c == "class1" }
  end

  test "cn handles empty input" do
    result = @helper.cn
    assert_equal "", result
  end

  test "cn handles only nil values" do
    result = @helper.cn(nil, nil)
    assert_equal "", result
  end
end
