return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
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
