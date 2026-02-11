# Node/Yarn configuration
# TODO: Read Node/Yarn versions from .nvmrc/package.json.

node_version = nil
yarn_version = nil

DEFAULT_NODE_VERSION = "22"

begin
  if yes?("Do you need Node.js?")

    node_version = ask(
      "Which Node version do you want to install?",
      default: DEFAULT_NODE_VERSION
    ) || ""

    say_status :info, "Node: #{node_version}"

    if File.file?("yarn.lock")
      yarn_version = ask("Which Yarn version do you want to install?", default: "latest") || ""

      say_status :info, "Yarn: #{node_version}"
    end
  end
end
