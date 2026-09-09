return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    input = { enabled = true },
    -- scroll = { enabled = vim.g.neovide == nil },
    indent = {
      enabled = true,
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        style = "out",
        easing = "outSine", -- https://github.com/kikito/tween.lua?tab=readme-ov-file#easing-functions
        duration = {
          step = 20,        -- ms per step
          total = 200,      -- maximum duration
        },
      },
    },
    picker = {
      enabled = true,
    },
    ---@class snacks.notifier.Config
    notifier = {
      timeout = 3000,
    },
    ---@class snacks.terminal.Config
    terminal = {
      win = {
        border = "rounded"
      },
      -- ...
    }
  },
  init = function()
    local Snacks = require("snacks")
    local notifier = require("snacks.notifier")

    local term_counter = 0
    ---
    ---@type integer|nil
    local term_focus = 1

    ---@type snacks.terminal.Opts
    local term_opts =
    {
      win = {
        title_pos = "left",
        title = "Quick terminal",
        b = {
          quick_terminal = true,
        },
      },
      auto_close = false,
    }
    ---@type snacks.win[]
    local terminals = {}

    local function resolve_snacks_term(buf)
      for _, t in ipairs(Snacks.terminal.list()) do
        if t.buf == buf then
          return t
        end
      end
    end

    ---@param term snacks.win
    ---@return integer|nil
    local function tindex(term)
      return vim.iter(ipairs(terminals)):find(function(_, t)
        return t == term
      end)
    end

    local function refresh_titles()
      for i, t in ipairs(terminals) do
        t:set_title(("Quick terminal [%d/%d]"):format(i, #terminals))
      end
    end

    local function cycle_terminal(term, dir)
      assert(#terminals > 0)

      if #terminals < 2 then
        return terminals[1]
      end

      local term_index = vim.iter(ipairs(terminals)):find(function(_, t)
        return t == term
      end)
      local next_index = term_index + dir

      if next_index > #terminals then
        next_index = 1
      elseif next_index < 1 then
        next_index = #terminals
      end

      return terminals[next_index]
    end

    local function move_terminal(term, dir)
      local term_index = tindex(term)
      assert(term_index ~= nil)

      local new_index = term_index + dir

      if new_index < 1 or new_index > #terminals then
        return
      end

      terminals[term_index], terminals[new_index] = terminals[new_index], terminals[term_index]
      term_focus = new_index
      refresh_titles()
    end

    Snacks.keymap.set("n", "<Bar>n", function() notifier.show_history() end)

    Snacks.keymap.set("n", "<C-q>", function()
      if #terminals > 0 then
        terminals[term_focus]:toggle()
      else
        term_counter = term_counter + 1
        local term = Snacks.terminal.toggle("fish", vim.tbl_extend("force", term_opts, {
          env = {
            QUICK_TERMINAL_ID = tostring(term_counter)
          }
        }))
        table.insert(terminals, term)
        term_focus = 1
      end

      refresh_titles()
    end)

    local aug = vim.api.nvim_create_augroup("SnacksTerminalCustomization", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = aug,
      pattern = "snacks_terminal",
      callback = function(ev)
        if not vim.b[ev.buf].quick_terminal then
          return
        end

        local term = resolve_snacks_term(ev.buf)
        local opts = { buffer = ev.buf }

        Snacks.keymap.set({ "t", "n", }, "<C-q>", function()
          term:hide()
        end, opts)

        Snacks.keymap.set({ "t", "n", }, "<A-n>", function()
          local term_index = tindex(term)
          assert(term_index ~= nil)

          term_counter = term_counter + 1

          local new_term = Snacks.terminal.open("fish", vim.tbl_extend("force", term_opts, {
            env = {
              QUICK_TERMINAL_ID = tostring(term_counter)
            }
          }))
          table.insert(terminals, term_index + 1, new_term)

          term_focus = term_index + 1

          refresh_titles()

          vim.schedule(function()
            term:hide()
          end)
        end, opts)

        Snacks.keymap.set({ "t", "n", }, "<A-h>", function()
          local next_term = cycle_terminal(term, -1)
          next_term:show()
          term_focus = tindex(next_term)
          assert(term_focus ~= nil)

          vim.schedule(function()
            term:hide()
          end)
        end, opts)

        Snacks.keymap.set({ "t", "n", }, "<A-l>", function()
          local next_term = cycle_terminal(term, 1)
          next_term:show()
          term_focus = tindex(next_term)
          assert(term_focus ~= nil)

          vim.schedule(function()
            term:hide()
          end)
        end, opts)

        Snacks.keymap.set({ "t", "n", }, "<A-H>", function()
          move_terminal(term, -1)
        end, opts)

        Snacks.keymap.set({ "t", "n", }, "<A-L>", function()
          move_terminal(term, 1)
        end, opts)
      end
    })

    vim.api.nvim_create_autocmd("TermClose", {
      group = aug,
      callback = function(ev)
        if not vim.api.nvim_buf_is_valid(ev.buf)
            or vim.bo[ev.buf].filetype ~= "snacks_terminal"
            or not vim.b[ev.buf].quick_terminal then
          return
        end

        local term = resolve_snacks_term(ev.buf)

        ---@type snacks.win|nil
        local prev = cycle_terminal(term, -1)

        if prev == term then
          prev = nil
        end

        if prev ~= nil and prev:buf_valid() then
          prev:show()
        end

        terminals = vim.tbl_filter(function(t)
          return t ~= term
        end, terminals)

        assert(term_focus ~= nil)
        term_focus = prev and tindex(prev) or math.min(term_focus, math.max(#terminals, 1))

        refresh_titles()

        vim.defer_fn(function()
          term:destroy()
        end, 100)
      end
    })
  end,
}
