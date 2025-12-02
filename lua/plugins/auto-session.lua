return {
  "rmagatti/auto-session",
  lazy = false,
  init = function()
    -- ...
  end,
  opts = {
    auto_save = true,
    auto_create = true,
    auto_restore = true,
    suppressed_dirs = { "/home", "/home/tomas", "/home/tomas/Desktop", "/home/tomas/bin" },
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
  end
}
