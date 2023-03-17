# frozen_string_literal: true

require "test_helper"

class DockerfileTest < GeneratorTestCase
  template <<~CODE
    postgres_version = "13"
    node_version = "14"
    yarn_version = "latest"

    file "Dockerfile", <%= code("Dockerfile") %>
  CODE

  def test_default_dockerfile
    run_generator

    assert_file_contains(
      "Dockerfile",
      "curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc"
    )

    assert_file_contains(
      "Dockerfile",
      "curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x"
    )

    assert_file_contains(
      "Dockerfile",
      "RUN npm install -g yarn"
    )
  end
end

class DockerfileMinimalTest < GeneratorTestCase
  template <<~CODE
    postgres_version = nil
    node_version = nil
    yarn_version = nil

    file "Dockerfile", <%= code("Dockerfile") %>
  CODE

  def test_minimal_dockerfile
    run_generator

    refute_file_contains(
      "Dockerfile",
      "RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc"
    )

    refute_file_contains(
      "Dockerfile",
      "RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x"
    )

    refute_file_contains(
      "Dockerfile",
      "RUN npm install -g yarn"
    )
  end
end
