# frozen_string_literal: true

require "erb"

class TemplateRenderer
  attr_reader :contents, :root

  def initialize(contents, root:)
    @contents = contents
    @root = root
  end

  def render
    ERB.new(contents).result(binding)
  end

  def code(path)
    contents = File.read(resolve_path(path))
    %Q(<<-CODE
#{contents}
CODE)
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
  ).freeze

  def resolve_path(path)
    PATH_CANDIDATES.each do |pattern|
      resolved = File.join(root, pattern % {path: path})
      return resolved if File.file?(resolved)
    end

    raise "File not found: #{path}"
  end
end