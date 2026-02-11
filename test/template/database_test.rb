# frozen_string_literal: true

require "test_helper"

class DatabaseTest < GeneratorTestCase
  template %q(
    gemspecs = {}

    <%= include "database" %>

    puts "DATABASE=#{database_adapter ? database_adapter : 'nope'}"
  )

  def test_with_supported_database
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which database adapter do you use? (postgresql)"
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

  def test_with_unconventional_database_yml
    prepare_dummy do
      FileUtils.rm(File.join("config", "database.yml"))
      File.write(File.join("config", "database.yml"), <<~'YML')
        <%
          config_path = if Fizzy.saas?
            gem_path = Rails.root.join("saas").to_s
            File.join(gem_path, "config", "database.yml")
          else
            File.join("config", "database.#{Fizzy.db_adapter}.yml")
          end
        %>
        <%= ERB.new(File.read(config_path)).result %>
      YML
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
