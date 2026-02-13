# Check if Claude CLI is available and offer to run it for polishing the configuration

claude_available = system("which claude > /dev/null 2>&1")

if claude_available
  if yes?("Would you like to run Claude to review and polish your Docker configuration?")
    # Build the prompt with todos
    todos_text = todos.map { |t| t.sub(/^\s*-?\s*/, "- ") }.join("\n")

    prompt = <<~PROMPT
      I just set up a Docker development environment for this Rails application using the "Ruby on Whales" template.

      ## Generated files

      The following files were created in `#{DOCKER_DEV_ROOT}/`:
      - `Dockerfile` - Multi-stage Docker image for development
      - `compose.yml` - Docker Compose configuration
      - `Aptfile` - System dependencies
      - `README.md` - Usage documentation

      And `dip.yml` in the project root for the Dip CLI.

      ## TODOs

      #{todos_text}

      ## Your tasks

      1. **Polish the generated configuration** — review the files in `#{DOCKER_DEV_ROOT}/` and `dip.yml` against the project's actual structure (check database.yml, Gemfile, etc.) and fix any issues directly.
      2. **Complete the mandatory TODOs** listed above (e.g., add DATABASE_URL to database.yml). Apply fixes directly without asking. Do not ask questions.
      3. **Create a `TODO.md` file** in `#{DOCKER_DEV_ROOT}/` listing optional next steps the user may want to configure later (system tests, Vite, CI, etc.).

      Exit the session when done (so the installer can get control back). Do not provide lengthy explanations.

      ## References

      For more context, see these guides:
      - [Ruby on Whales: Dockerizing Ruby and Rails development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development) - The main guide this template is based on
      - [System of a test: Dockerizing system tests](https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing#dockerizing-system-tests) - For setting up system/integration tests with Docker
      - [Vite-lizing Rails: Dockerizing Vite](https://evilmartians.com/chronicles/vite-lizing-rails-get-live-reload-and-hot-replacement-with-vite-ruby#dockerizing-vite-or-not) - For Vite.js integration with Docker
    PROMPT

    say_status :info, "Handing over to Claude to review your Docker setup...\n"
    say ""

    claude_cmd = ["claude", "--allowedTools", "Read,Edit,Write,Glob,Grep,Bash(git:*)", "-p", prompt]

    output = if defined?(Gum) && ENV["RBYTES_DISABLE_GUM"] != "1"
      Gum.spin("Claude is thinking...") do
        IO.popen(claude_cmd, &:read)
      end
    else
      IO.popen(claude_cmd, &:read)
    end

    say "Here is what Claude said", :blue
    print_wrapped output
    say "\n"
    say ""
  end
end
