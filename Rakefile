# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc "Run component tests"
Rake::TestTask.new(:test_components) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/components/**/*_test.rb"]
  t.verbose = true
end

desc "Run generator tests"
Rake::TestTask.new(:test_generators) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/generators/**/*_test.rb"]
  t.verbose = true
end

task default: :test
