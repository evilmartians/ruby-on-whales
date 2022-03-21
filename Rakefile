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

desc "Push installation template to RailsBytes"
task :publish_template do
  require "net/http"
  require "json"

  token, account_id = ENV.fetch("RAILS_BYTES_TOKEN"), ENV.fetch("RAILS_BYTES_ACCOUNT_ID")

  template_id = "z5OsoB"
  uri = URI("https://railsbytes.com/api/v1/accounts/#{account_id}/templates/#{template_id}.json")
  request = Net::HTTP::Patch.new(uri)
  request["Authorization"] = "Bearer #{token}"
  request.content_type = "application/json"

  tmpl = Rake::Task["build_template"].execute.first.call
  request.body = JSON.dump(script: tmpl)

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end
end

task default: %w[test:isolated]
