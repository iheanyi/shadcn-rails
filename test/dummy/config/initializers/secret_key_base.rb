# frozen_string_literal: true

# Set a dummy secret key base for development/test
Rails.application.config.secret_key_base = "test_secret_key_base_for_dummy_app_#{SecureRandom.hex(32)}"
