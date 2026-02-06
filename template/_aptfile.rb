# Generates the Aptfile with system deps

apt_deps = [
  "# An editor to work with credentials",
  "vim"
]

begin
  deps = []

  if %[sqlite sqlite3].include?(database_adapter)
    deps << "sqlite3"
  end

  if gemspecs.key?("ruby-vips")
    deps << "libvips"
  end

  loop do
    dep = ask("Would like to install additional system packages?#{deps.any? ? " (We have: #{deps.join(", ")})" : ""} (Type a name or press ENTER to continue)") || ""
    break if dep.empty?
    deps << dep
  end

  if !deps.empty?
    apt_deps.concat(["# Application dependencies"] + deps)
  end
end
