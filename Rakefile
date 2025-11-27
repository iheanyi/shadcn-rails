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

# Release tasks
namespace :release do
  desc "Check if versions are in sync between Ruby gem and npm package"
  task :check_versions do
    ruby_version = File.read("lib/shadcn/rails/version.rb").match(/VERSION = "(.+?)"/)[1]
    npm_version = JSON.parse(File.read("package.json"))["version"]

    puts "Ruby gem version: #{ruby_version}"
    puts "npm package version: #{npm_version}"

    if ruby_version == npm_version
      puts "\n✓ Versions are in sync"
    else
      puts "\n✗ Versions are out of sync!"
      exit 1
    end
  end

  desc "Bump version (usage: rake 'release:bump[patch]' or rake 'release:bump[1.0.0]')"
  task :bump, [:type] do |_, args|
    type = args[:type] || "patch"
    system("bin/bump #{type}")
  end

  desc "Bump version without committing (usage: rake 'release:bump_only[patch]')"
  task :bump_only, [:type] do |_, args|
    type = args[:type] || "patch"
    system("bin/bump #{type} --no-commit")
  end

  desc "Build both gem and npm package"
  task :build do
    puts "Building npm package..."
    system("npm run build") || abort("npm build failed")

    puts "\nBuilding gem..."
    system("gem build shadcn-rails.gemspec") || abort("gem build failed")

    puts "\n✓ Both packages built successfully"
  end

  desc "Run all tests (Ruby and JavaScript)"
  task :test do
    puts "Running Ruby tests..."
    Rake::Task["test"].invoke

    puts "\nRunning JavaScript tests..."
    system("npm test") || abort("JavaScript tests failed")

    puts "\n✓ All tests passed"
  end

  desc "Prepare for release (check versions, run tests, build packages)"
  task prepare: [:check_versions, "release:test", :build]

  desc "Full release (run bin/release script)"
  task :publish do
    exec("bin/release")
  end

  desc "Dry run of release (shows what would happen)"
  task :dry_run do
    exec("bin/release --dry-run")
  end
end

desc "Show current version"
task :version do
  require_relative "lib/shadcn/rails/version"
  puts Shadcn::Rails::VERSION
end
