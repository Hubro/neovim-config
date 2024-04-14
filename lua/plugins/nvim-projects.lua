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
      vim.cmd.SessionSave()
    end,
    after_jump = function(_)
      vim.cmd.SessionRestore()
    end,
  },
}
