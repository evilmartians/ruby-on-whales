# frozen_string_literal: true

require "test_helper"

class LSPRubyLSPTest < GeneratorTestCase
  template %q(
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {
      "ruby-lsp" => Gem::Version.new("1.0.0")
    }

    <%= include "lsp" %>
  )

  def test_when_has_ruby_lsp
    run_generator do |output|
      assert_file_contains ".dockerdev_test/ruby-lsp", <<~CODE
        cd $(dirname $0)/..

        dip ruby-lsp $@
      CODE
    end
  end
end

class LSPSolargraphTest < GeneratorTestCase
  template %q(
    DOCKER_DEV_ROOT = ".dockerdev_test"

    gemspecs = {
      "solargraph" => Gem::Version.new("1.0.0")
    }

    <%= include "lsp" %>
  )

  def test_when_has_solargraph
    run_generator do |output|
      assert_file_contains ".dockerdev_test/solargraph", <<~CODE
        cd $(dirname $0)/..

        dip solargraph $@
      CODE
    end
  end
end
