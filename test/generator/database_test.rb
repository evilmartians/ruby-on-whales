# frozen_string_literal: true

require "test_helper"

class DatabaseTest < GeneratorTestCase
  template %q(
    <%= include "database" %>
    puts "DATABASE=#{database_adapter ? database_adapter : 'nope'}"
  )

  def test_with_supported_database
    run_generator do |input, output|
      input.puts
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
    FileUtils.rm(File.join(rails_root, "config", "database.yml"))

    run_generator do |input, output|
      input.puts "elenadb"
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
