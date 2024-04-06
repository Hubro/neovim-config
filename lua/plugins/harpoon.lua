return {
  "ThePrimeagen/harpoon",
  config = function(harpoon)
    local h_mark = require("harpoon.mark")
    local h_ui = require("harpoon.ui")

    vim.keymap.set({ "n" }, "<Leader>.", h_mark.add_file)
    vim.keymap.set({ "n" }, "<Leader>h", h_ui.toggle_quick_menu)
    vim.keymap.set({ "n" }, "<Leader>j", h_ui.nav_next)
    vim.keymap.set({ "n" }, "<Leader>k", h_ui.nav_prev)
  end,
}
