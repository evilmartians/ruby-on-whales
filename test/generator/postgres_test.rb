# frozen_string_literal: true

require "test_helper"

class PostgresTest < GeneratorTestCase
  template %q(
    database_adapter = "postgres"
    <%= include "postgres" %>

    puts "POSTGRES_VERSION=#{postgres_version}"
  )

  def test_default_postgres_version
    run_generator do |input, output|
      input.puts ""
      assert_line_printed(
        output,
        "Which PostgreSQL version do you want to install? (Press ENTER to use 14)"
      )

      assert_line_printed(
        output,
        "POSTGRES_VERSION=14"
      )
    end
  end

  def test_custom_postgres_version
    run_generator do |input, output|
      input.puts "11.3"
      assert_line_printed(
        output,
        "Which PostgreSQL version do you want to install? (Press ENTER to use 14)"
      )

      assert_line_printed(
        output,
        "POSTGRES_VERSION=11.3"
      )
    end
  end
end
