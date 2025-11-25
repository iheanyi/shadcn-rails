# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: %i[test]

namespace :dummy do
  desc "Start the dummy app server"
  task :server do
    Dir.chdir("test/dummy") do
      system("bin/rails server")
    end
  end

  desc "Run dummy app console"
  task :console do
    Dir.chdir("test/dummy") do
      system("bin/rails console")
    end
  end
end
