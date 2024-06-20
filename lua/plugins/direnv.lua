return {
  "direnv/direnv.vim",
  event = "VeryLazy",
  init = function()
    vim.g.direnv_silent_load = true

    local cached_direnv_diff = nil

    local group = vim.api.nvim_create_augroup("DirenvLoaded", { clear = true })
    vim.api.nvim_create_autocmd({ "User" }, {
      group = group,
      pattern = "DirenvLoaded",
      callback = function()
        if vim.env.DIRENV_DIFF ~= cached_direnv_diff then
          cached_direnv_diff = vim.env.DIRENV_DIFF

          vim.notify("Loaded environment from direnv")

          if vim.cmd.LspRestart ~= nil then
            -- vim.notify("Restarting LSP servers")
            vim.cmd.LspRestart()
          end
        end
      end
    })
  end
}
