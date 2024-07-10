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
  },
  init = function()
    vim.keymap.set("n", "got", ":ObsidianToday<CR>")
    vim.keymap.set("n", "<Bar>of", ":ObsidianQuickSwitch<CR>")
    vim.keymap.set("n", "<Bar>os", ":ObsidianSearch<CR>")
  end,
  opts = {
    callbacks = {
      enter_node = function()
        vim.bo.conceallevel = 2
        vim.bo.tabstop = 4
      end
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
        },
      },
      {
        name = "Telia",
        path = "~/Documents/Obsidian/Telia",
      },
    },
    templates = {
      folder = "Templates",
    },
  },
}
