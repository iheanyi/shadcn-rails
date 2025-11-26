# frozen_string_literal: true

# Use the dummy app's own Gemfile if it exists, otherwise fall back to parent
local_gemfile = File.expand_path("../../Gemfile", __dir__)
parent_gemfile = File.expand_path("../../../Gemfile", __dir__)

ENV["BUNDLE_GEMFILE"] ||= File.exist?(local_gemfile) ? local_gemfile : parent_gemfile

require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
