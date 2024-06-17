local M = {}

M.load_local_nvimrc = function()
  local nvimrc = vim.fn.fnamemodify(vim.fn.getcwd() .. "/.nvimrc.lua", ":p")

  if vim.fn.filereadable(nvimrc) == 1 then
    vim.cmd("source " .. nvimrc)

    -- Defer for a moment so the notify plugin has time to get loaded
    vim.defer_fn(function()
      vim.notify("Loaded .nvimrc.lua from current directory")
    end, 200)
  end
end

return M
