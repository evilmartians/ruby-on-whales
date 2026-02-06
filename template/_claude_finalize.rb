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

      ## TODOs to complete

      #{todos_text}

      ## Your tasks

      1. **Review the generated configuration** - Check the files in `#{DOCKER_DEV_ROOT}/` and `dip.yml` to ensure they match the project's needs
      2. **Complete the TODOs** - Help me address each item listed above
      3. **Suggest improvements** - Based on this project's structure, suggest any additional Docker configuration that might be helpful
      4. **Document the setup** - Create or update documentation appropriate for this project:
         - If CLAUDE.md or AGENTS.md exists, add Docker-related instructions there
         - If there's a docs/ folder, consider adding a Docker setup guide
         - Otherwise, ensure #{DOCKER_DEV_ROOT}/README.md is comprehensive

      IMPORTANT: Provide the user with a TODO list of changes before applying them. Explain every change and why it's needed (based on the materials provided, use links if necessary). Allow the user to pick only ones to implement right now and postpone others (ask if needed to document somewhere).

      Exit the session after done with configuring the Docker setup (so the installer can get control back).

      ## References

      For more context, see these guides:
      - [Ruby on Whales: Dockerizing Ruby and Rails development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development) - The main guide this template is based on
      - [System of a test: Dockerizing system tests](https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing#dockerizing-system-tests) - For setting up system/integration tests with Docker
      - [Vite-lizing Rails: Dockerizing Vite](https://evilmartians.com/chronicles/vite-lizing-rails-get-live-reload-and-hot-replacement-with-vite-ruby#dockerizing-vite-or-not) - For Vite.js integration with Docker
    PROMPT

    say_status :info, "Handing over to Claude to review your Docker setup...\n"

    # Use fork + exec to hand over control to Claude for interactive session
    # while allowing the parent process to complete
    pid = fork do
      exec(
        "claude",
        prompt
      )
    end
    Process.wait(pid)
  end
end
