# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

namespace :test do
  task :isolated do
    Dir.glob("test/**/*_test.rb").all? do |file|
      sh(Gem.ruby, "-I#{__dir__}/lib:#{__dir__}/test", file)
    end || raise("Failures")
  end
end

desc "Generate installation template"
task :compile do
  require "ruby_bytes/cli"
  RubyBytes::CLI.new.run("compile", "./template/ruby-on-whales.rb")
end

task default: %w[test:isolated]
