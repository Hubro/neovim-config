return {
  cmd = { "home-assistant-lsp", "--stdio" },
  -- cmd = {
  --   "/usr/bin/node",
  --   "/opt/vscode-home-assistant/out/server/server.js",
  --   "--stdio",
  -- },
  filetypes = { "yaml" },
  root_markers = { "configuration.yaml" },
  settings = {},
}
