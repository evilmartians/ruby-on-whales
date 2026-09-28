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

  def test_with_erb_and_multi_database_yml
    prepare_dummy do
      FileUtils.rm(File.join("config", "database.yml"))
      File.write(File.join("config", "database.yml"), <<~'YML')
        <% data_path = ENV.fetch("SQLITE_DATA_PATH", "db") %>
        default: &default
          adapter: sqlite3
          max_connections: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
          timeout: 5000

        development:
          primary:
            <<: *default
            database: <%= File.join(data_path, "development", "data.sqlite3") %>
          queue:
            <<: *default
            database: <%= File.join(data_path, "development", "queue.sqlite3") %>
      YML
    end

    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which database adapter do you use? (sqlite3)"
      )
      assert_line_printed(
        output,
        "DATABASE=sqlite3"
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
