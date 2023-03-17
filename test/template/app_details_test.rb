# frozen_string_literal: true

require "test_helper"

class AppDetailsTest < GeneratorTestCase
  template %q(
    # <%= include "app_details" %>
    puts "APP_NAME=#{app_name}"
  )

  def test_app_name_from_application_module
    run_generator do |output|
      assert_line_printed(
        output,
        "APP_NAME=dummy"
      )
    end
  end
end
