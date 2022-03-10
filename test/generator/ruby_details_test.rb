# frozen_string_literal: true

require "test_helper"

class RubyDetailsTest < GeneratorTestCase
  template %q(
    <%= include "ruby_details" %>
    puts "RUBY_VERSION=#{ruby_version}"
  )

  def test_when_ruby_version_is_present
    run_generator do |input, output|
      input.puts
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.0.2)"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=3.0.2"
      )
    end
  end

  def test_when_ruby_version_is_provided_by_user
    run_generator do |input, output|
      input.puts "3.1.0"
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.0.2)"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=3.1.0"
      )
    end
  end

  def test_when_ruby_version_is_incorrect
    run_generator do |input, output|
      input.puts "3_1z2b0\n3.1.1"
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.0.2)"
      )
      assert_line_printed(
        output,
        "Invalid version. Please, try again"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=3.1.1"
      )
    end
  end
end
