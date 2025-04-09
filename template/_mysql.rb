# Specify PostgreSQL version

mysql_version = nil
mysql_image = "mysql"

DEFAULT_MYSQL_VERSION = "8.0"
MYSQL_ADAPTERS = %w[mysql2 trilogy]

if MYSQL_ADAPTERS.include?(database_adapter)
  begin
    selected_mysql_version = ask "Which MySQL version do you want to install? (Press ENTER to use #{DEFAULT_MYSQL_VERSION})"

    mysql_version = selected_mysql_version.empty? ? DEFAULT_MYSQL_VERSION : selected_mysql_version
    database_url = "#{database_adapter}://root:root@mysql:3306"
  end
end
