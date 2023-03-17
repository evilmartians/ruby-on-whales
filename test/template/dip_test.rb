# frozen_string_literal: true

require "test_helper"

class DipTest < GeneratorTestCase
  template <<~CODE
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {
      "redis" => Gem::Version.new("6.0.0"),
      "rspec" => Gem::Version.new("4.0.0")
    }
    postgres_version = "13.2"
    yarn_version = "1.22"
    redis_version = "5.0"
    app_name = "app-name"

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
  end
end
