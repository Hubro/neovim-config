return {
  "rmagatti/auto-session",
  dependencies = { "nvim-telescope/telescope.nvim" },
  init = function()
    -- Ref: https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    local group = vim.api.nvim_create_augroup("AutoSaveSession", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = group,
      callback = function()
        local as = require("auto-session")
        if as.session_exists_for_cwd() then
          as.AutoSaveSession(nil)
        end
      end
    })
  end,
  opts = {
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    auto_session_suppress_dirs = { "~/", "~/Desktop", "~/bin" },
    pre_save_cmds = {
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
  config = function(_, opts)
    require("auto-session").setup(opts)
    require("telescope").load_extension("session-lens")
  end
}
