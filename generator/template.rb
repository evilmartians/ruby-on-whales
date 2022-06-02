say "👋 Welcome to interactive Ruby on Whales installer 🐳.\n" \
    "Make sure you've read the guide: https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development"

DOCKER_DEV_ROOT = ".dockerdev"

# Prepare variables and utility files
<%= include "app_details" %>
<%= include "ruby_details" %>
<%= include "aptfile" %>
<%= include "database" %>
<%= include "postgres" %>
<%= include "node" %>
<%= include "redis" %>

# Generate configuration
file "#{DOCKER_DEV_ROOT}/Dockerfile", <%= code("Dockerfile") %>
file "#{DOCKER_DEV_ROOT}/compose.yml", <%= code("compose.yml") %>
file "dip.yml", <%= code("dip.yml") %>

file "#{DOCKER_DEV_ROOT}/.bashrc", <%= code(".bashrc") %>
if postgres_version
  file "#{DOCKER_DEV_ROOT}/.psqlrc", <%= code(".psqlrc") %>
end

file "#{DOCKER_DEV_ROOT}/README.md", <%= code("README.md") %>

todos = [
  "📝  Important things to take care of:",
  "  - Make sure you have `ENV[\"RAILS_ENV\"] = \"test\"` (not `ENV[\"RAILS_ENV\"] ||= \"test\"`) in your test helper."
]

if database_url
  todos << "  - Don't forget to add `url: \<\%= ENV[\"DATABASE_URL\"] \%\>` to your database.yml"
end

if todos.any?
  say_status(:warn, todos.join("\n"))
end

say_status :info, "✅  You're ready to sail! Check out #{DOCKER_DEV_ROOT}/README.md or run `dip provision && dip up web` 🚀"
