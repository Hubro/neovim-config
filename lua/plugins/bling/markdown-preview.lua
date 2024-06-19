return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
  init = function()
    vim.g.mkdp_browser = "/run/current-system/sw/bin/vivaldi"
    vim.g.mkdp_port = 32080
    vim.g.mkdp_echo_preview_url = 1
  end
}
