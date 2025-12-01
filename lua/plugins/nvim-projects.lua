return {
  "Hubro/nvim-projects",
  dev = true,
  --dir = "~/projects/nvim-projects",
  -- name = "nvim-projects",
  event = "VeryLazy",
  cmd = { "Project" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "rcarriga/nvim-notify",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    init_filename = ".nvimrc.lua",
    project_dirs = {
      "~/projects",
      "~/syncthing/dotfiles",
      "~/Dropbox/Projects",
      "~/Dropbox/Avesta/Inhouse projects",
      "~/Dropbox/Avesta Projects",
      "~/Dropbox/Telia/src/github",
    },
    exclude = {
      "/.stversions/",
    },
    before_jump = function(_)
      local as = require("auto-session")
      as.AutoSaveSession()
    end,
    after_jump = function(_)
      local as = require("auto-session")

      -- Restore session if one exists, otherwise open Oil
      if as.session_exists_for_cwd() then
        as.RestoreSession("")
        vim.notify("Restored previous session")
      else
        vim.cmd.edit "."
      end
    end,
  },
}
