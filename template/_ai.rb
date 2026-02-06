claude = yes?("Would you like to install Claude Code CLI inside a container and run it from there?")

if claude
  apt_deps.concat([
    "# Claude",
    "bubblewrap",
    "socat"
  ])
end
