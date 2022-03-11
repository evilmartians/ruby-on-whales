# frozen_string_literal: true

require "erb"

class TemplateRenderer
  attr_reader :template, :root

  def initialize(template, root:)
    @template = template
    @root = root
  end

  def render(contents = template)
    ERB.new(contents, trim_mode: "<>").result(binding)
  end

  def code(path)
    contents = File.read(resolve_path(path))
%Q(ERB.new(
  *[
<<~'CODE'
#{contents}
CODE
], trim_mode: "<>").result(binding))
  end

  def include(path)
    File.read(resolve_path(path))
  end

  private

  PATH_CANDIDATES = %w(
    %{path}
    _%{path}
    %{path}.rb
    _%{path}.rb
    %{path}.tt
    _%{path}.tt
  ).freeze

  def resolve_path(path)
    PATH_CANDIDATES.each do |pattern|
      resolved = File.join(root, pattern % {path: path})
      return resolved if File.file?(resolved)
    end

    raise "File not found: #{path}"
  end
end
