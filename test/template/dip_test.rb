# frozen_string_literal: true

require "test_helper"

class DipTest < GeneratorTestCase
  template <<~CODE
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {
      "redis" => Gem::Version.new("6.0.0"),
      "rspec" => Gem::Version.new("4.0.0"),
      "ruby-lsp" => Gem::Version.new("0.2.20")
    }

    postgres_version = "13.2"
    yarn_version = "1.22"
    redis_version = "5.0"
    app_name = "app-name"
    claude = true

    file "dip.yml", <%= code("dip.yml") %>
  CODE

  def test_default_dip_configuration
    run_generator

    assert_file_contains(
      "dip.yml",
<<-CODE
compose:
  files:
    - .dockerdev_test/compose.yml
  project_name: app-name
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
  rspec:
    description: Run RSpec commands
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
  psql:
    description: Run Postgres psql console
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
  'redis-cli':
    description: Run Redis console
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
  ruby-lsp:
    description: Run Ruby LSP
    service: rails
    command: bundle exec ruby-lsp
    compose_run_options: [ service-ports, no-deps ]
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
  claude:
    description: Run Claude CLI
    service: rails
    command: claude --dangerously-skip-permissions
CODE
    )
  end
end

class DipMinimalTest < GeneratorTestCase
  template <<~CODE
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {}
    postgres_version = nil
    yarn_version = nil
    redis_version = nil
    app_name = "app-name"
    claude = false

    file "dip.yml", <%= code("dip.yml") %>
  CODE

  def test_minimal_dip_configuration
    run_generator

    assert_file_contains(
      "dip.yml",
<<-CODE
      test:
        description: Run unit tests
        service: rails
        command: bundle exec rails test
        environment:
          RAILS_ENV: test
CODE
    )

    refute_file_contains(
      "dip.yml",
<<-CODE
  rspec:
    description: Run RSpec commands
CODE
    )

    refute_file_contains(
      "dip.yml",
<<-CODE
  psql:
    description: Run Postgres psql console
CODE
    )

    refute_file_contains(
      "dip.yml",
<<-CODE
  'redis-cli':
    description: Run Redis console
CODE
    )

    refute_file_contains(
      "dip.yml",
<<-CODE
  claude:
    description: Run Claude CLI
CODE
    )
  end
end

class DipSidekiqProTest < GeneratorTestCase
  template <<~CODE
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {
      "sidekiq-pro" =>  Gem::Version.new("7.0.0"),
    }
    postgres_version = nil
    yarn_version = nil
    redis_version = "7.0.0"
    app_name = "app-name"
    claude = false

    file "dip.yml", <%= code("dip.yml") %>
  CODE

  def test_sidekiq_pro_dip_configuration
    run_generator

    assert_file_contains(
      "dip.yml",
<<-'CODE'
  configure_bundler_credentials:
    command: |
      (test -f .bundle/config && cat .bundle/config | \
        grep BUNDLE_ENTERPRISE__CONTRIBSYS__COM > /dev/null) ||
      \
        (echo "Sidekiq ent credentials ("user:pass"): "; read -r creds; dip bundle config --local enterprise.contribsys.com $creds)
CODE
    )

    assert_file_contains(
      "dip.yml",
<<-CODE
provision:
  - '[[ "$RESET_DOCKER" == "true" ]] && echo "Re-creating the Docker env from scratch..." && dip compose down --volumes || echo "Re-provisioning the Docker env..."'
  - dip configure_bundler_credentials
CODE
    )
  end
end
