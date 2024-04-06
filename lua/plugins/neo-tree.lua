return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "main",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  opts = {
    window = {
      mappings = {
        ["<c-x>"] = "open_split",
        ["<m-x>"] = "split_with_window_picker",
        ["<c-v>"] = "open_vsplit",
        ["<m-v>"] = "vsplit_with_window_picker",
        ["<c-t>"] = "open_tabnew",
        ["<bs>"] = "close_node",
        ["z"] = "",
        ["zO"] = "expand_all_nodes",
        ["zM"] = "close_all_nodes",
      },
    },
    filesystem = {
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,   -- Toggle with H
        hide_dotfiles = true,
        hide_gitignored = true,
        always_show = {
          ".github",
          ".gitignore",
          ".dockerignore",
        },
      },
      window = {
        mappings = {
          ["/"] = "",   -- Disable the annoying filter function
        }
      }
    },
    default_component_configs = {
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖", -- this can only be used in the git_status source
          renamed   = "󰁕", -- this can only be used in the git_status source

          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        },
      },
    },
  },
}
