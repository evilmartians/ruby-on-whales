# frozen_string_literal: true

require "test_helper"

class NodeTest < GeneratorTestCase
  template %q(
    <%= include "node" %>

    puts "NODE_VERSION=#{node_version ? node_version : 'nope'}"
    puts "YARN_VERSION=#{yarn_version}"
  )

  def test_default_node_versions
    run_generator(input: ["\r"]) do |output|
      assert_line_printed(
        output,
        "Which Node version do you want to install? (Press ENTER to use 16, type 'n/no' to skip installing Node)"
      )

      assert_line_printed(
        output,
        "Which Yarn version do you want to install? (Press ENTER to install the latest one)"
      )

      assert_line_printed(
        output,
        "NODE_VERSION=16"
      )

      assert_line_printed(
        output,
        "YARN_VERSION=latest"
      )
    end
  end

  def test_custom_node_versions
    run_generator(input: ["14","1.13.0"]) do |output|
      assert_line_printed(
        output,
        "Which Node version do you want to install? (Press ENTER to use 16, type 'n/no' to skip installing Node)"
      )

      assert_line_printed(
        output,
        "Which Yarn version do you want to install? (Press ENTER to install the latest one)"
      )

      assert_line_printed(
        output,
        "NODE_VERSION=14"
      )

      assert_line_printed(
        output,
        "YARN_VERSION=1.13.0"
      )
    end
  end

  def test_skip_node
    run_generator(input: ["n"]) do |output|
      assert_line_printed(
        output,
        "Which Node version do you want to install? (Press ENTER to use 16, type 'n/no' to skip installing Node)"
      )
      assert_line_printed(
        output,
        "NODE_VERSION=nope"
      )
    end
  end
end
