# Change log

## main

- Add `dip claude:update` command and persist Claude CLI binaries in the `claude_cli` volume (updates survive container restarts).
- Mount `/tmp` tmpfs with `exec` to support CLIs that execute from `/tmp` (e.g., tailwindcss).
- Add `clauder` shell alias (`claude --dangerously-skip-permissions`).

## 2.1.0

- TUI refactoring (better use of Thor built-in capabilities and preparation for Thor Charmed).

## 2.0.0

- Added Claude-delegation: ask AI to finalize the installation (if present)
- Add Claude Code CLI to the container (`dip claude`)
- More configurations/features supported: LSPs, Vite, MySQL

## 1.1.0

- Fix CMD in Dockerfile. ([@palkan][])

- Allow skipping Yarn install. ([@palkan][])

## 1.0.0

- Automatic publish to RailsBytes in CI. ([@fargelus][])

[@fargelus]: https://github.com/fargelus
[@palkan]: https://github.com/palkan
