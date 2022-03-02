# frozen_string_literal: true

require "test_helper"

class GeneratorTest < Minitest::Test
  def test_genertor_compiles
    assert TemplateRenderer.new(File.read(File.join(GENERATOR_ROOT, "template.rb")), root: GENERATOR_ROOT).render
  end
end
