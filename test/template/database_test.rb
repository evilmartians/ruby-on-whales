# frozen_string_literal: true

require "test_helper"

class DatabaseTest < GeneratorTestCase
  template %q(
    <%= include "database" %>
    puts "DATABASE=#{database_adapter ? database_adapter : 'nope'}"
  )

  def test_with_supported_database
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which database adapter do you use? (Press ENTER to use postgresql)"
      )
      assert_line_printed(
        output,
        "DATABASE=postgresql"
      )
    end
  end

  def test_with_unsupported_database
    prepare_dummy do
      FileUtils.rm(File.join("config", "database.yml"))
    end

    run_generator(input: ["elenadb"]) do |output|
      assert_line_printed(
        output,
        "Which database adapter do you use?"
      )
      assert_line_printed(
        output,
        "Unfortunately, we do no support elenadb yet"
      )
    end
  end
end
