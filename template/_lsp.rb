# Configure Ruby LSP

begin
  if gemspecs.key?("ruby-lsp")
    file "#{DOCKER_DEV_ROOT}/ruby-lsp", <%= code("ruby-lsp") %>

    chmod "#{DOCKER_DEV_ROOT}/ruby-lsp", 0755
  end

  if gemspecs.key?("solargraph")
    file "#{DOCKER_DEV_ROOT}/solargraph", <%= code("solargraph") %>

    chmod "#{DOCKER_DEV_ROOT}/solargraph", 0755
  end
end
