say "👋 Welcome to interactive Ruby on Whales installer 🐳. " \
    "Make sure you've read the guide: https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development"

DOCKER_DEV_ROOT = ".dockerdev"

<%= include "ruby_details" %>
<%= include "aptfile" %>
<%= include "database" %>

say_status :info, "✅  You're ready to sail!"
