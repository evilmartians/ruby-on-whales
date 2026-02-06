# Generates the Aptfile with system deps

apt_deps = [
  "# An editor to work with credentials",
  "vim"
]

begin
  deps = []
  loop do
    dep = ask("Which system package do you want to install? (Press ENTER to continue)") || ""
    break if dep.empty?
    deps << dep
  end

  if !deps.empty?
    apt_deps.concat(["# Application dependencies"] + deps)
  end
end
