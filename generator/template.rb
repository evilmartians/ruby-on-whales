say "👋 Welcome to interactive Ruby on Whales installer 🐳. " \
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

say_status :info, "✅  You're ready to sail!"

if database_url
  say_status :warn, "Don't forget to add `url: <%= ENV['DATABASE_URL']` to your database.yml"
end
