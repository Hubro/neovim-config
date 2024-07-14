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
        template = "Journal entry.md",
        no_write = true,
      }

      if not note:exists() then
        client:write_note(note)
      end

      client:open_note(note)
    end)
    vim.keymap.set("n", "<Bar>nf", ":ObsidianQuickSwitch<CR>")
    vim.keymap.set("n", "<Bar>ns", ":ObsidianSearch<CR>")
  end,
  opts = {
    callbacks = {
      enter_note = function()
        vim.bo.tabstop = 4
      end
    },
    new_notes_location = "0 - 🏠 Inbox",
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
        path = "~/Documents/Obsidian/Personal",
        overrides = {
          daily_notes = {
            folder = "Health log",
            date_format = "%Y-%m-%d - %A",
            template = "Health log entry.md",
          },
          templates = {
            folder = "~/Documents/Obsidian/Personal/Templates",
          },
        },
      },
      {
        name = "Telia",
        path = "~/Documents/Obsidian/Telia",
        overrides = {
          templates = {
            folder = "~/Documents/Obsidian/Telia/Templates",
          },
        },
      },
    },
  },
}
