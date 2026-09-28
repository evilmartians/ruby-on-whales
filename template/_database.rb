# Set up database related variables, create files

database_adapter = nil
database_url = nil

begin
  supported_adapters = %w(postgresql postgis postgres mysql2 trilogy sqlite3 sqlite)

  config_path = "config/database.yml"

  if File.file?(config_path)
    require "yaml"
    # Strip ERB tags, so the file could be parsed as YAML
    config_yml = File.read(config_path).gsub(/\<\%.*?\%\>/m, "")
    maybe_database_adapter = begin
      ::YAML.safe_load(config_yml, aliases: true) || {}
    rescue ArgumentError
      ::YAML.safe_load(config_yml) || {}
    rescue ::Psych::Exception
      {}
    end.then do |conf|
      next unless conf.is_a?(Hash)

      # Support multi-database configuration
      conf.dig("development", "adapter") || conf.dig("development", "primary", "adapter")
    end
  end

  # check gems if database.yml is non-standard
  unless maybe_database_adapter
    maybe_database_adapter =
      case
      when gemspecs.include?("sqlite3") then "sqlite3"
      when gemspecs.include?("pg") then "postgresql"
      when gemspecs.include?("trilogy") then "trilogy"
      when gemspecs.include?("mysql2") then "mysql2"
      end
  end

  selected_database_adapter = ask "Which database adapter do you use?", default: maybe_database_adapter

  selected_database_adapter = maybe_database_adapter if selected_database_adapter.nil? || selected_database_adapter.empty?

  if supported_adapters.include?(selected_database_adapter)
    database_adapter = selected_database_adapter
    say_status :info, "Database: #{database_adapter}"
  else
    say_status :warn, "Unfortunately, we do no support #{selected_database_adapter} yet. Please, configure it yourself"
  end
end
