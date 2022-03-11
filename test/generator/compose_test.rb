# frozen_string_literal: true

require "test_helper"

class ComposeTest < GeneratorTestCase
  template <<~CODE
    ruby_version = "2.7.1"
    gemspecs = {
      "webpacker" => Gem::Version.new("6.0.0"),
      "sidekiq" => Gem::Version.new("6.0.0")
    }
    postgres_version = "13.2"
    database_url = "postgresql://postgres:postgres@postgres:5432"
    node_version = "14.2"
    yarn_version = "1.22.17"
    redis_version = "5.0"
    app_name = "app-name"

    file "compose.yml", <%= code("compose.yml") %>
  CODE

  def test_default_compose
    run_generator

    assert_file_contains(
      "compose.yml",
<<-CODE
  build:
    context: .
    args:
      RUBY_VERSION: '2.7.1'
      PG_MAJOR: '13'
      NODE_MAJOR: '14'
      YARN_VERSION: '1.22.17'
  image: app-name-dev:1.0.0
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  postgres:
    image: postgres:13.2
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  redis:
    image: redis:5.0-alpine
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  webpacker:
    <<: *app
    command: bundle exec ./bin/webpack-dev-server
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  sidekiq:
    <<: *backend
    command: bundle exec sidekiq
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
volumes:
  bundle:
  node_modules:
  history:
  rails_cache:
  postgres:
  redis:
  packs:
  packs-test:
CODE
    )
  end
end

class ComposeMinimalTest < GeneratorTestCase
  template <<~CODE
    ruby_version = "3.0"
    gemspecs = {}
    postgres_version = nil
    database_url = nil
    node_version = nil
    yarn_version = nil
    redis_version = nil
    app_name = "app-name"

    file "compose.yml", <%= code("compose.yml") %>
  CODE

  def test_minimal_compose
    run_generator

    assert_file_contains(
      "compose.yml",
<<-CODE
  build:
    context: .
    args:
      RUBY_VERSION: '3.0'
  image: app-name-dev:1.0.0
CODE
    )

    refute_file_contains(
      "compose.yml",
<<-CODE
  postgres:
    image: postgres:13.2
CODE
    )

    refute_file_contains(
      "compose.yml",
<<-CODE
  redis:
    image: redis:5.0-alpine
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
volumes:
  bundle:
  history:
  rails_cache:
CODE
    )
  end
end
