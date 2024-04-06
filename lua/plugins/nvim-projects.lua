return {
  name = "nvim-projects",
  dir = "~/projects/nvim-projects",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "rcarriga/nvim-notify",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    init_filename = ".nvimrc.lua",
    project_dirs = {
      "~/projects",
      "~/Dropbox/Projects",
      "~/Dropbox/Avesta/Inhouse projects",
      "~/Dropbox/Avesta Projects",
      "~/Dropbox/Telia/src/github",
    },
    after_jump = function(_)
      vim.cmd("NeoTreeShow")
      vim.cmd([[ exec "normal \<c-w>\<c-w>" ]])
    end,
  },
}
