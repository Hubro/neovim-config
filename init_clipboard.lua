-- If in tmux over SSH, use tmux buffer as the clipboard
if vim.env.TMUX and (vim.env.SSH_CONNECTION or vim.env.SSH_TTY) then
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = { "tmux", "load-buffer", "-" },
      ["*"] = { "tmux", "load-buffer", "-" },
    },
    paste = {
      ["+"] = { "tmux", "save-buffer", "-" },
      ["*"] = { "tmux", "save-buffer", "-" },
    },
    cache_enabled = 0,
  }
end
