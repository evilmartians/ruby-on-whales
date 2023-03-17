# frozen_string_literal: true

require "test_helper"

class AptfileTest < GeneratorTestCase
  template %q(
    DOCKER_DEV_ROOT = ".dockerdev_test"

    <%= include "aptfile" %>
  )

  def test_when_no_known_dependencies_present
    run_generator(input: [""]) do |output|
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to continue)"
      )
    end

    assert_file_contains ".dockerdev_test/Aptfile", <<~CODE
      # An editor to work with credentials
      vim
    CODE
  end

  def test_with_user_provided_deps
    run_generator(input: ["ntp"]) do |output|
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to continue)"
      )
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to continue)"
      )
    end

    assert_file_contains ".dockerdev_test/Aptfile", <<~CODE
      # An editor to work with credentials
      vim
      # Application dependencies
      ntp
    CODE
  end
end
