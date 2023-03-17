# frozen_string_literal: true

require "test_helper"

class RubyDetailsTest < GeneratorTestCase
  template %q(
    <%= include "ruby_details" %>
    puts "RUBY_VERSION=#{ruby_version}"
  )

  def test_when_ruby_version_is_present
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.2.1)"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=3.2.1"
      )
    end
  end

  def test_when_no_lockfile
    prepare_dummy do
      FileUtils.rm("Gemfile.lock")
    end

    run_generator(input: ["2.7.5"]) do |output|
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (For example, 3.2.0)"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=2.7.5"
      )
    end
  end

  def test_when_ruby_version_is_provided_by_user
    run_generator(input: ["3.1.0"]) do |output|
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.2.1)"
      )
      assert_line_printed(
        output,
        "RUBY_VERSION=3.1.0"
      )
    end
  end

  def test_when_ruby_version_is_incorrect
    run_generator(input: ["3_1z2b0", "3.1.1"]) do |output|
      assert_line_printed(
        output,
        "Which Ruby version would you like to use? (Press ENTER to use 3.2.1)"
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
