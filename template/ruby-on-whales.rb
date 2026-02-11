say "👋 Welcome to interactive Ruby on Whales installer.", :cyan
say "We'll help you to configure a Docker development environment for your Rails project."
say "\n"
say "Read the full guide here:"
say "https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development", :blue
say ""

DOCKER_DEV_ROOT = ".dockerdev"

# Prepare variables and utility files
<%= include "app_details" %>
<%= include "ruby_details" %>
<%= include "database" %>
<%= include "postgres" %>
<%= include "mysql" %>
<%= include "node" %>
<%= include "redis" %>
<%= include "aptfile" %>
<%= include "ai" %>

# Generate configuration
aptfile = File.join(DOCKER_DEV_ROOT, "Aptfile")
FileUtils.mkdir_p(File.dirname(aptfile))
File.write(aptfile, apt_deps.join("\n") + "\n")

file "#{DOCKER_DEV_ROOT}/Dockerfile", <%= code("Dockerfile") %>
file "#{DOCKER_DEV_ROOT}/compose.yml", <%= code("compose.yml") %>
file "dip.yml", <%= code("dip.yml") %>

file "#{DOCKER_DEV_ROOT}/.bashrc", <%= code(".bashrc") %>
if postgres_version
  file "#{DOCKER_DEV_ROOT}/.psqlrc", <%= code(".psqlrc") %>
end

if claude
  file "#{DOCKER_DEV_ROOT}/.claude.json.example", "{}"
  file "#{DOCKER_DEV_ROOT}/.gitignore", "/.claude.json\n"
end

file "#{DOCKER_DEV_ROOT}/README.md", <%= code("README.md") %>

todos = []

if database_url
  todos << "  - Don't forget to add `url: \<\%= ENV[\"DATABASE_URL\"] \%\>` to your database.yml"
end

if todos.any?
  say_status(:warn, "📝  Important things to take care of:")
  print_wrapped todos.join("\n")
end

<%= include "claude_finalize" %>

say "✅  You're ready to sail!", :cyan
say "\n"
say "Check out #{DOCKER_DEV_ROOT}/README.md or run `dip provision && dip up web` 🚀"
say ""
