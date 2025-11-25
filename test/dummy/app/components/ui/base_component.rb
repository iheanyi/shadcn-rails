# frozen_string_literal: true

module Ui
  class BaseComponent < ApplicationComponent
    private

    def cn(*classes)
      classes.flatten.compact.uniq.join(" ")
    end

    def generate_id(prefix = "shadcn")
      "#{prefix}-#{SecureRandom.hex(4)}"
    end
  end
end
