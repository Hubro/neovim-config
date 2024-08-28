-- Return a function that disables floaterm autoinsert while executing
local function without_floaterm_auto_insert(fn)
  return function()
    local backup = vim.g.floaterm_autoinsert
    vim.g.floaterm_autoinsert = false

    pcall(fn)

    vim.g.floaterm_autoinsert = backup
  end
end

local aug = vim.api.nvim_create_augroup("FloatermCustomization", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "floaterm",
  callback = function()
    local opts = { silent = true, buffer = 0, }

    vim.keymap.set("n", "<A-h>", without_floaterm_auto_insert(function()
      vim.cmd("FloatermPrev")
    end), opts)

    vim.keymap.set("t", "<A-h>", function()
      vim.cmd("FloatermPrev")
    end, opts)

    vim.keymap.set("n", "<A-l>", without_floaterm_auto_insert(function()
      vim.cmd("FloatermNext")
    end), opts)

    vim.keymap.set("t", "<A-l>", function()
      vim.cmd("FloatermNext")
    end, opts)

    vim.keymap.set({ "n", "t" }, "<C-q>", function()
      vim.cmd("FloatermHide")
    end, opts)

    vim.keymap.set({ "n", "t" }, "<A-n>", function()
      vim.cmd("FloatermNew")
    end, opts)

    -- Ctrl+Shift+V already works for pasting from the system
    -- clipboard, these binds make it more practical to paste
    -- from a register
    vim.keymap.set({ "n", "t" }, "<C-S-R>", function()
      local register = vim.fn.getcharstr()
      local text = vim.fn.getreg(register)
      local lines = vim.split(text, "\n", { plain = true })
      vim.api.nvim_put(lines, "c", false, true)
    end, opts)
    vim.keymap.set({ "n", "t" }, "<C-S-P>", '<C-S-R>"', { remap = true })
  end
})
