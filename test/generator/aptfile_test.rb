# frozen_string_literal: true

require "test_helper"

class AptfileTest < GeneratorTestCase
  template %q(
    DOCKER_DEV_ROOT = ".dockerdev_test"

    <%= include "aptfile" %>
  )

  def test_when_no_known_dependencies_present
    run_generator do |input, output|
      input.puts
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to skip)"
      )
    end

    assert_file_contains ".dockerdev_test/Aptfile", <<~CODE
      # An editor to work with credentials
      vim
    CODE
  end

  def test_with_user_provided_deps
    run_generator do |input, output|
      input.puts "ntp\r\n"
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to skip)"
      )
      assert_line_printed(
        output,
        "Which system package do you want to install? (Press ENTER to skip)"
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
