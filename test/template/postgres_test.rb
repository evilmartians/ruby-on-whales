# frozen_string_literal: true

require "test_helper"

class PostgresTest < GeneratorTestCase
  template %q(
    database_adapter = "postgres"
    <%= include "postgres" %>

    puts "POSTGRES_VERSION=#{postgres_version}"
  )

  def test_default_postgres_version
    run_generator(input: [""]) do |output|
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
    run_generator(input: ["11.3"]) do |output|
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

class PostgisTest < GeneratorTestCase
  template %q(
    database_adapter = "postgis"
    <%= include "postgres" %>

    puts "POSTGRES_IMAGE=#{postgres_base_image}:#{postgres_version}"
  )

  def test_default_postgres_version
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which PostgreSQL version do you want to install? (Press ENTER to use 14)"
      )

      assert_line_printed(
        output,
        "POSTGRES_IMAGE=postgis/postgis:14"
      )
    end
  end
end
