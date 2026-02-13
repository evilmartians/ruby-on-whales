# frozen_string_literal: true

require "test_helper"

class ClaudeFinalizeTest < GeneratorTestCase
  template <<~'CODE'
    DOCKER_DEV_ROOT = ".dockerdev"
    todos = [
      "📝  Important things to take care of:",
      "  - Make sure you have `ENV[\"RAILS_ENV\"] = \"test\"` (not `ENV[\"RAILS_ENV\"] ||= \"test\"`) in your test helper.",
      "  - Don't forget to add DATABASE_URL to your database.yml"
    ]

    <%= include "claude_finalize" %>
  CODE

  def setup
    super
    @mock_bin = File.expand_path("../fixtures/bin", __dir__)
    @claude_output_file = File.join(TMP_DIR, "claude_args.txt")
  end

  def test_runs_claude_with_correct_arguments
    original_path = ENV["PATH"]
    ENV["PATH"] = "#{@mock_bin}:#{original_path}"
    ENV["CLAUDE_MOCK_OUTPUT"] = @claude_output_file

    begin
      run_generator(input: ["y"]) # "y" for yes? prompt
    ensure
      ENV["PATH"] = original_path
      ENV.delete("CLAUDE_MOCK_OUTPUT")
    end

    assert File.exist?(@claude_output_file), "Mock claude should have been called"

    args = File.read(@claude_output_file)

    # Check prompt content includes todos
    assert_includes args, "Ruby on Whales"
    assert_includes args, "Important things to take care of"
    assert_includes args, "ENV[\"RAILS_ENV\"] = \"test\""
    assert_includes args, "DATABASE_URL"

    # Check prompt includes TODO.md instruction
    assert_includes args, "TODO.md"

    # Check prompt includes references
    assert_includes args, "evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development"
    assert_includes args, "system-of-a-test"
    assert_includes args, "vite-lizing-rails"

    # Check --allowedTools flag is passed
    assert_includes args, "--allowedTools"
  end

  def test_skips_when_user_declines
    original_path = ENV["PATH"]
    ENV["PATH"] = "#{@mock_bin}:#{original_path}"
    ENV["CLAUDE_MOCK_OUTPUT"] = @claude_output_file

    begin
      run_generator(input: ["n"]) # "n" for no
    ensure
      ENV["PATH"] = original_path
      ENV.delete("CLAUDE_MOCK_OUTPUT")
    end

    refute File.exist?(@claude_output_file), "Mock claude should not have been called when user declines"
  end

  def test_skips_when_claude_unavailable
    # Don't add mock bin to PATH, so claude won't be found
    ENV["CLAUDE_MOCK_OUTPUT"] = @claude_output_file
    original_path = ENV["PATH"]
    ENV["PATH"] = __dir__

    begin
      run_generator(input: []) # No input needed since prompt won't appear
    ensure
      ENV["PATH"] = original_path
      ENV.delete("CLAUDE_MOCK_OUTPUT")
    end

    refute File.exist?(@claude_output_file), "Mock claude should not have been called when unavailable"
  end
end
