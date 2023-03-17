# Generates the Aptfile with system deps
DEFAULT_APTFILE = <<~CODE
  # An editor to work with credentials
  vim
CODE

begin
  deps = []
  loop do
    dep = ask("Which system package do you want to install? (Press ENTER to continue)") || ""
    break if dep.empty?
    deps << dep
  end

  aptfile = File.join(DOCKER_DEV_ROOT, "Aptfile")
  FileUtils.mkdir_p(File.dirname(aptfile))

  app_deps =
    if deps.empty?
      "\n"
    else
      (["# Application dependencies"] + deps + [""]).join("\n")
    end

  File.write(aptfile, DEFAULT_APTFILE + app_deps)
end
