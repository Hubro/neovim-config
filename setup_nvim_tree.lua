local success, nvim_tree = pcall(require, "nvim-tree")

-- Don't bother crashing loudly if nvim-tree isn't installed
if success then
  local lib = require("nvim-tree.lib")

  local git_add = function()
    local node = lib.get_node_at_cursor()

    local gs = node.git_status

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
      vim.cmd("silent !git add " .. node.absolute_path)

    -- If the file is staged, we unstage
    elseif gs == "M " or gs == "A " then
      vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end

    lib.refresh_tree()
  end

  local git_rm = function()
    local node = lib.get_node_at_cursor()

    local gs = node.git_status

    vim.cmd("silent !git rm " .. node.absolute_path)

    lib.refresh_tree()
  end

  local debug = function()
    local node = lib.get_node_at_cursor()

    print(vim.inspect(node))
  end

  nvim_tree.setup({
    hijack_cursor = true,
    sync_root_with_cwd = true,
    view = {
      width = 60,
      preserve_window_proportions = true,
      mappings = {
        list = {
          { key = "cd", action = "cd" },
          { key = "ga", action = "git_add", action_cb = git_add },
          { key = "gd", action = "git_rm", action_cb = git_rm },
          { key = "<Leader>d", action = "debug", action_cb = debug },
        },
      },
    },
    filters = {},
  })
end
