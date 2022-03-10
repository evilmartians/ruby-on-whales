# frozen_string_literal: true

begin
  require "debug"
rescue LoadError
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "open3"
require "expect"
require "template_renderer"

require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

TMP_DIR = File.join(__dir__, "../tmp/generator_tests")
GENERATOR_ROOT = File.join(__dir__, "../generator")
RAILS_APP_PATH = File.join(__dir__, "fixtures", "basic_rails_app")

FileUtils.rm_rf(TMP_DIR) if File.directory?(TMP_DIR)
FileUtils.mkdir_p(TMP_DIR)

class GeneratorTestCase < Minitest::Test
  class << self
    attr_reader :current_template

    def template(contents)
      path = File.join(TMP_DIR, "current_template_#{Time.now.to_i}-#{rand(10)}.rb")
      rendered = TemplateRenderer.new(contents, root: GENERATOR_ROOT).render
      File.write(path, rendered)

      @current_template = path
    end
  end

  attr_reader :rails_root

  def setup
    @rails_root = File.join(TMP_DIR, "rails_app_#{Time.now.to_i}-#{rand(10)}")
    FileUtils.cp_r(RAILS_APP_PATH, @rails_root)
  end

  def teardown
    FileUtils.rm_rf(@rails_root)
  end

  def run_generator
    Bundler.with_unbundled_env do
      Open3.popen2e(
        {},
        "bundle exec rails app:template LOCATION=#{File.expand_path(self.class.current_template)}",
        chdir: @rails_root
      ) do |stdin, stdout_or_err, wait_thr|
        stdin.sync = true
        stdout_or_err.sync = true
        yield stdin, stdout_or_err
      ensure
        puts stdout_or_err.read unless wait_thr.value.success?
      end
    end
  end

  def assert_line_printed(io, line)
    assert io.expect(line, 2), "Expected to print line: #{line}. Got: #{io.instance_variable_get(:@unusedBuf)}"
  end

  def assert_file_contains(path, body)
    fullpath = File.join(rails_root, path)
    assert File.file?(fullpath), "File not found: #{path}"

    actual = File.read(fullpath)
    assert_includes actual, body
  end
end
