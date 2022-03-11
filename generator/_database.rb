# Set up database related variables, create files

database_adapter = nil
database_url = nil

begin
  supported_adapters = %w(postgresql postgis postgres)

  config_path = "config/database.yml"

  if File.file?(config_path)
    require "yaml"
    maybe_database_adapter = begin
      ::YAML.load_file(config_path, aliases: true) || {}
    rescue ArgumentError
      ::YAML.load_file(config_path) || {}
    end.dig("development", "adapter")
  end

  selected_database_adapter =
    if maybe_database_adapter
      ask "Which database adapter do you use? (Press ENTER to use #{maybe_database_adapter})"
    else
      ask "Which database adapter do you use?"
    end

  selected_database_adapter = maybe_database_adapter if selected_database_adapter.empty?

  if supported_adapters.include?(selected_database_adapter)
    database_adapter = selected_database_adapter
  else
    say_status :warn, "Unfortunately, we do no support #{selected_database_adapter} yet. Please, configure it yourself"
  end
end
