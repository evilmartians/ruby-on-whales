# Node/Yarn configuration
# TODO: Read Node/Yarn versions from .nvmrc/package.json.

node_version = nil
yarn_version = nil

DEFAULT_NODE_VERSION = "16"

begin
  selected_node_version = ask(
    "Which Node version do you want to install? (Press ENTER to use 16, type 'n/no' to skip installing Node)"
  ) || ""

  unless selected_node_version =~ /^\s*no?\s*$/
    node_version = selected_node_version.empty? ? DEFAULT_NODE_VERSION : selected_node_version

    yarn_version = ask("Which Yarn version do you want to install? (Press ENTER to install the latest one)") || ""
    yarn_version = "latest" if yarn_version.empty?
  end
end
