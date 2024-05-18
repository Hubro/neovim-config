local scan_dir = require("plenary.scandir").scan_dir

M = {
  root_dir = vim.fn.expand("~/.local/share/nvim/sessions")
}

M.list_sessions = function()
  local session_files = scan_dir(M.root_dir, { add_dirs = false, depth = 1 })

  local sessions = vim.tbl_map(function(path)
    local project_path = vim.fn.fnamemodify(path, ":t:r"):gsub("%%", "/")
    local project_name = vim.fn.fnamemodify(project_path, ":t")
    local project_dir = vim.fn.fnamemodify(project_path, ":h")

    return {
      path = path,
      project_path = project_path,
      project_name = project_name,
      project_dir = project_dir,
      stat = vim.uv.fs_stat(path),
    }
  end, session_files)

  table.sort(sessions, function(a, b)
    return a.stat.mtime.sec > b.stat.mtime.sec
  end)

  return sessions
end

--- @param opts table?
M.session_picker = function(opts)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local entry_display = require('telescope.pickers.entry_display')
  local finders = require("telescope.finders")
  local utils = require('telescope.utils')
  local conf = require('telescope.config').values

  local autosession = require("auto-session")

  local sessions = M.list_sessions()

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 2 },
      { width = nil },
      { remaining = true },
    }
  })

  local dropdownOpts = require('telescope.themes').get_dropdown()
  local defaultOpts = vim.tbl_deep_extend("force", dropdownOpts, {
    prompt_title = "Sessions",
    layout_config = {
      width = 70,
      height = 0.3,
    },
    finder = finders.new_table({
      results = sessions,
      entry_maker = function(entry)
        return {
          value = entry,
          path = entry.path,
          ordinal = entry.project_name,
          display = function()
            local icon, iconhl = utils.get_devicons(entry.path)

            return displayer({
              { icon,                     iconhl },
              { entry.project_dir .. "/", "TelescopeResultsComment" },
              { entry.project_name,       "Bold" },
            })
          end
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local nope = function() end

      map({ "i", "n" }, "<C-s>", nope)
      map({ "i", "n" }, "<C-x>", nope)
      map({ "i", "n" }, "<C-v>", nope)
      map({ "i", "n" }, "<C-t>", nope)

      -- Restore a session
      map({ "n", "i" }, "<CR>", function()
        actions.close(prompt_bufnr)

        local entry = action_state.get_selected_entry()

        autosession.RestoreSession(entry.path)
      end)

      -- Delete a session
      map({ "n", "i" }, "<C-d>", function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)

        current_picker:delete_selection(function(deleted_entry)
          return pcall(vim.uv.fs_unlink, deleted_entry.path)
        end)
      end)

      return true
    end,
  })

  opts = opts or {}
  pickers.new(opts, defaultOpts):find()
end

return M
