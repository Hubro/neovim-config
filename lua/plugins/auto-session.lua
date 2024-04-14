return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  init = function()
    -- Ref: https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  opts = {
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    pre_save_cmds = {
      "tabdo Neotree close",
      function()
        -- ...
      end
    },
    post_restore_cmds = {
      function()
        -- ...
      end
    },
    session_lens = {
      load_on_setup = true,
    },
  },
}
