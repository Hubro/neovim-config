return {
  "direnv/direnv.vim",
  event = "VeryLazy",
  init = function()
    vim.g.direnv_silent_load = true

    local cached_direnv_diff = nil
    local env_loaded = false

    local group = vim.api.nvim_create_augroup("DirenvLoaded", { clear = true })
    vim.api.nvim_create_autocmd({ "User" }, {
      group = group,
      pattern = "DirenvLoaded",
      callback = function()
        if vim.env.DIRENV_DIFF ~= cached_direnv_diff then
          cached_direnv_diff = vim.env.DIRENV_DIFF

          if not env_loaded then
            vim.notify("Loaded environment from direnv, restarting LSP servers")
            env_loaded = true
          else
            vim.notify("Reloaded environment from direnv, restarting LSP servers")
          end

          for _, client in ipairs(vim.lsp.get_clients()) do
            vim.cmd.LspRestart(client.name)
          end
        end
      end
    })
  end
}
