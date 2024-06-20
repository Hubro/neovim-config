return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = false,
  init = function()
    -- ...
  end,
  opts = {
    -- auto_session_enable_last_session = true,
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    -- auto_session_use_git_branch = true,
    auto_session_suppress_dirs = { "/home/tomas", "/home/tomas/Desktop", "/home/tomas/bin" },
    cwd_change_handling = {
      restore_upcoming_session = false, -- nvim-projects handles this
    },
    pre_save_cmds = {
      function()
        require("hubro.close_floats")()
        require("notify").dismiss({})
      end
    },
    post_restore_cmds = {
      function()
        -- ...
      end
    },
    -- I'm using my own, much superior picker (see hubro.session)
    -- session_lens = {
    --   load_on_setup = true,
    -- },
  },
  config = function(_, opts)
    require("auto-session").setup(opts)
    require("telescope").load_extension("session-lens")
  end
}
