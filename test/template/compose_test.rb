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
    mysql_version = nil
    database_url = "postgresql://postgres:postgres@postgres:5432"
    node_version = "14.2"
    yarn_version = "1.22.17"
    redis_version = "5.0"
    app_name = "app-name"
    claude = true

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
  claude:
CODE
    )
  end
end

class ComposeViteMysqlTest < GeneratorTestCase
  template <<~CODE
    ruby_version = "3.4.1"
    gemspecs = {
      "vite_ruby" => Gem::Version.new("3.0.19")
    }
    postgres_version = nil
    mysql_version = 8.0
    database_url = nil
    yarn_version = nil
    redis_version = nil
    node_version = "20"
    app_name = "app-name"
    claude = false

    file "compose.yml", <%= code("compose.yml") %>
  CODE

  def test_compose_with_vite_and_mysql
    run_generator

    assert_file_contains(
      "compose.yml",
<<-CODE
  build:
    context: .
    args:
      RUBY_VERSION: '3.4.1'
      NODE_MAJOR: '20'
  image: app-name-dev:1.0.0
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  mysql:
    image: mysql:8.0
    volumes:
      - mysql_data:/var/lib/mysql
      - history:/usr/local/hist
    command: --default-authentication-plugin=mysql_native_password
    ports:
      - 3306
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: 1
    healthcheck:
      test: mysqladmin ping -h 127.0.0.1 -u root
      interval: 5s
CODE
    )

    assert_file_contains(
      "compose.yml",
<<-CODE
  vite:
    <<: *backend
    command: ./bin/vite dev
    volumes:
      - ${PWD}:/${PWD}:cached
      - bundle:/usr/local/bundle
      - node_modules:/${PWD}/node_modules
      - vite_dev:/${PWD}/public/vite-dev
      - vite_test:/${PWD}/public/vite-test
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
  mysql_data:
  vite_dev:
  vite_test:
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
    mysql_version = nil
    node_version = nil
    yarn_version = nil
    redis_version = nil
    app_name = "app-name"
    claude = false

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
