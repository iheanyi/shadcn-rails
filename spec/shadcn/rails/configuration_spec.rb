# frozen_string_literal: true

RSpec.describe Shadcn::Rails::Configuration do
  subject(:configuration) { described_class.new }

  describe "#initialize" do
    it "sets default components_path" do
      expect(configuration.components_path).to eq("app/components/ui")
    end

    it "sets default tailwind_config_path" do
      expect(configuration.tailwind_config_path).to eq("config/tailwind.config.js")
    end

    it "sets default styles" do
      expect(configuration.default_styles).to include(
        rounded: "rounded-md",
        shadow: "shadow-sm",
        transition: "transition-colors"
      )
    end
  end

  describe "#components_path=" do
    it "allows setting custom components path" do
      configuration.components_path = "app/views/ui"
      expect(configuration.components_path).to eq("app/views/ui")
    end
  end

  describe "#tailwind_config_path=" do
    it "allows setting custom tailwind config path" do
      configuration.tailwind_config_path = "tailwind.config.js"
      expect(configuration.tailwind_config_path).to eq("tailwind.config.js")
    end
  end
end
