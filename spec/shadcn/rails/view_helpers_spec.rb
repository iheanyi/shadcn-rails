# frozen_string_literal: true

RSpec.describe Shadcn::Rails::ViewHelpers do
  let(:helper_class) do
    Class.new do
      include Shadcn::Rails::ViewHelpers
    end
  end

  let(:helper) { helper_class.new }

  describe "#cn" do
    it "joins multiple classes" do
      result = helper.cn("class1", "class2", "class3")
      expect(result).to include("class1")
      expect(result).to include("class2")
      expect(result).to include("class3")
    end

    it "handles nil values" do
      result = helper.cn("class1", nil, "class2")
      expect(result).to include("class1")
      expect(result).to include("class2")
      expect(result).not_to include("nil")
    end

    it "handles arrays of classes" do
      result = helper.cn(["class1", "class2"], "class3")
      expect(result).to include("class1")
      expect(result).to include("class2")
      expect(result).to include("class3")
    end

    it "removes duplicate classes" do
      result = helper.cn("class1", "class1", "class2")
      expect(result.split.count("class1")).to eq(1)
    end
  end
end
