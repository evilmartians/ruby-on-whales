# frozen_string_literal: true

require "test_helper"

class RedisTest < GeneratorTestCase
  template %q(
    gemspecs = {
      "redis" => Gem::Version.new("4.0.0")
    }

    <%= include "redis" %>

    puts "REDIS_VERSION=#{redis_version}"
  )

  def test_default_redis_version
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which Redis version do you want to use? (Press ENTER to use 6.0)"
      )

      assert_line_printed(
        output,
        "REDIS_VERSION=6.0"
      )
    end
  end

  def test_custom_redis_version
    run_generator(input: ["4.0"]) do |output|
      assert_line_printed(
        output,
        "Which Redis version do you want to use?"
      )

      assert_line_printed(
        output,
        "REDIS_VERSION=4.0"
      )
    end
  end
end


class RedisNotFoundTest < GeneratorTestCase
  template %q(
    gemspecs = {}

    <%= include "redis" %>

    puts "REDIS_VERSION=#{redis_version ? 'wat?!' : 'nope'}"
  )

  def test_no_redis_version
    run_generator do |output|
      assert_line_printed(
        output,
        "REDIS_VERSION=nope"
      )
    end
  end
end
