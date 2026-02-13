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
    deps << "libvips-dev"
  end

  say "Here is the list of system packages we're going to install:", :blue
  print_in_columns deps

  more_deps = ask("Would you like to install other packages? Type comma-separated names or press ENTER to continue") || ""

  user_deps = more_deps.split(/\s*,\s*/).map(&:strip)

  unless user_deps.empty?
    say "Additional packages:", :blue
    print_in_columns user_deps

    deps.concat(user_deps)
  end

  if !deps.empty?
    apt_deps.concat(["# Application dependencies"] + deps)
  end
end
