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
task :build_template do
  require_relative "lib/template_renderer"

  puts TemplateRenderer.new(File.read(File.join(__dir__, "generator", "template.rb")), root: File.join(__dir__, "generator")).render
end

task default: %w[test]
