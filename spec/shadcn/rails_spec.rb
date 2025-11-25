# frozen_string_literal: true

RSpec.describe Shadcn::Rails do
  it "has a version number" do
    expect(Shadcn::Rails::VERSION).not_to be_nil
  end

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(Shadcn::Rails::Configuration)
    end

    it "has default components_path" do
      expect(described_class.configuration.components_path).to eq("app/components/ui")
    end

    it "has default tailwind_config_path" do
      expect(described_class.configuration.tailwind_config_path).to eq("config/tailwind.config.js")
    end
  end

  describe ".configure" do
    after do
      described_class.reset_configuration!
    end

    it "allows setting configuration options" do
      described_class.configure do |config|
        config.components_path = "app/views/components"
      end

      expect(described_class.configuration.components_path).to eq("app/views/components")
    end
  end

  describe ".available_components" do
    it "returns an array of component names" do
      expect(described_class.available_components).to be_an(Array)
      expect(described_class.available_components).to include("button", "card", "input")
    end
  end

  describe ".component_exists?" do
    it "returns true for existing components" do
      expect(described_class.component_exists?(:button)).to be true
      expect(described_class.component_exists?("card")).to be true
    end

    it "returns false for non-existing components" do
      expect(described_class.component_exists?(:nonexistent)).to be false
    end
  end

  describe ".root" do
    it "returns the gem root path" do
      expect(described_class.root).to be_a(Pathname)
      expect(described_class.root.to_s).to include("shadcn-rails")
    end
  end

  describe ".components_path" do
    it "returns the path to component templates" do
      expect(described_class.components_path).to be_a(Pathname)
      expect(described_class.components_path.to_s).to include("templates/components")
    end
  end
end
