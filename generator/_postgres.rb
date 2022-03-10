# Specify PostgreSQL version

postgres_version = nil

DEFAULT_POSTGRES_VERSION = "14"

begin
  selected_postgres_version = ask "Which PostgreSQL version do you want to install? (Press ENTER to use #{DEFAULT_POSTGRES_VERSION})"

  postgres_version = selected_postgres_version.empty? ? DEFAULT_POSTGRES_VERSION : selected_postgres_version
end
