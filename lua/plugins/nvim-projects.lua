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
    after_jump = function(_)
      -- TODO: Restore session
    end,
  },
}
