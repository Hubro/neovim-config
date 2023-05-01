local nvim_tree = require("nvim-tree")
local lib = require("nvim-tree.lib")
local api = require("nvim-tree.api")

local git_add = function()
  local node = lib.get_node_at_cursor()

  if node then
    local gs = node.git_status.file

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
      vim.cmd("silent !git add " .. node.absolute_path)

      -- If the file is staged, we unstage
    elseif gs == "M " or gs == "A " then
      vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end

    api.tree.reload()
  end
end

local git_rm = function()
  local node = lib.get_node_at_cursor()

  if node then
    vim.cmd("silent !git rm " .. node.absolute_path)

    api.tree.reload()
  end
end

local debug = function()
  local node = lib.get_node_at_cursor()

  vim.notify(vim.inspect(node))
end

nvim_tree.setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return {
        desc = "nvim-tree: " .. desc,
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end

    -- Apply default mappings first
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "cd", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set("n", "ga", git_add, opts("Git add"))
    vim.keymap.set("n", "gr", git_rm, opts("Git remove"))
    vim.keymap.set("n", "<Leader>d", debug, opts("Debug node"))
  end,
  view = {
    width = 40,
    preserve_window_proportions = true,
    -- mappings = {
    --   list = {
    --     { key = "cd", action = "cd" },
    --     { key = "ga", action = "git_add", action_cb = git_add },
    --     { key = "gd", action = "git_rm", action_cb = git_rm },
    --     { key = "<Leader>d", action = "debug", action_cb = debug },
    --   },
    -- },
  },
  filters = {},
})
