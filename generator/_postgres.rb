# Specify PostgreSQL version

postgres_version = nil
postgres_base_image = "postgres"

DEFAULT_POSTGRES_VERSION = "14"
POSTGRES_ADAPTERS = %w[postgres postgresql postgis]

if POSTGRES_ADAPTERS.include?(database_adapter)
  begin
    selected_postgres_version = ask "Which PostgreSQL version do you want to install? (Press ENTER to use #{DEFAULT_POSTGRES_VERSION})"

    postgres_version = selected_postgres_version.empty? ? DEFAULT_POSTGRES_VERSION : selected_postgres_version
    database_url = "#{database_adapter}://postgres:postgres@postgres:5432"

    if database_adapter == "postgis"
      postgres_base_image = "postgis/postgis"
    end
  end
end
