local personal_notes_path = "~/Documents/Obsidian/Personal"
local telia_notes_path = "~/Documents/Obsidian/Telia"
local health_log_path = "Health log"
local journal_path = "Journal/Entries"

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~/Documents/Obsidian/**.md"),
    "BufNewFile " .. vim.fn.expand("~/Documents/Obsidian/**.md"),
  },
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianFollowLink",
    "ObsidianBacklinks",
    "ObsidianTags",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianDailies",
    "ObsidianTemplate",
    "ObsidianSearch",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianLinks",
    "ObsidianExtractNote",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianToggleCheckbox",
    "ObsidianNewFromTemplate",
    "ObsidianTOC",
  },
  init = function()
    vim.o.conceallevel = 2 -- So ** and such can be hidden

    -- Prefix "n" for "notes", "o" was taken...
    vim.keymap.set("n", "<Leader>nt", ":ObsidianToday<CR>")
    vim.keymap.set("n", "<Leader>nj", function()
      local client = require("obsidian").get_client()
      --- @type obsidian.Note
      local note = client:create_note {
        title = "Journal entry - " .. os.date("%Y-%m-%d %A"),
        id = os.date("%Y-%m-%d - %A"),
        dir = journal_path,
        no_write = true,
      }

      if not note:exists() then
        client:write_note(note, {
          template = "Journal entry.md",
        })
      end

      client:open_note(note)
    end)
    vim.keymap.set("n", "<Bar>nf", ":ObsidianQuickSwitch<CR>")
    vim.keymap.set("n", "<Bar>ns", ":ObsidianSearch<CR>")
  end,
  opts = {
    callbacks = {
      enter_note = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 0
      end
    },
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        return tostring(os.date("%Y-%m-%d", os.time()))
      end
    end,
    open_app_foreground = true,
    picker = {
      note_mappings = {
        new = nil,
      },
    },
    templates = {
      substitutions = {
        health_log_path = health_log_path,
        journal_path = journal_path,
        date_with_weekday = function()
          return os.date("%Y-%m-%d %A")
        end,
      },
    },
    attachments = {
      img_folder = "Attachments", -- Ugh, this is relative to the vault root...
    },
    workspaces = {
      {
        name = "Personal",
        path = personal_notes_path,
        overrides = {
          -- FIXME: This function is currently retarded, as it forces every new
          -- note to the inbox even if something else was explicitly provided.
          --
          ---@param spec { id: string, dir: obsidian.Path, title: string|? }
          ---@return string|obsidian.Path The full path to the new note.
          -- note_path_func = function(spec)
          --   return personal_notes_path .. "/0 - 🏠 Inbox/" .. spec.title .. ".md"
          -- end,
          daily_notes = {
            folder = "Health log",
            date_format = "%Y-%m-%d - %A",
            template = "Health log entry.md",
          },
          templates = {
            folder = personal_notes_path .. "/Templates",
          },
        },
      },
      {
        name = "Telia",
        path = "~/Documents/Obsidian/Telia",
        overrides = {
          templates = {
            folder = telia_notes_path .. "/Templates",
          },
        },
      },
    },
  },
}
