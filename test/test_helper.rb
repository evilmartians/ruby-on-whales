# frozen_string_literal: true

begin
  require "debug"
rescue LoadError
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "rbytes"
require "ruby_bytes/test_case"

require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class GeneratorTestCase < RubyBytes::TestCase
  root File.join(__dir__, "../template")
  dummy_app File.join(__dir__, "fixtures", "basic_rails_app")
end
