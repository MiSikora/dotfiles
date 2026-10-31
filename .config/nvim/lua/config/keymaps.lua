-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>", {
  noremap = true,
  silent = true,
})

-- Remove <Space>, <Backspace>, and <Enter> navigation
for _, key in ipairs({ "<Space>", "<BS>", "<CR>" }) do
  vim.keymap.set({ "n", "v" }, key, "<Nop>", {
    noremap = true,
    silent = true,
  })
end

-- Remove arrow navigation
for _, arrow in ipairs({ "<Left>", "<Down>", "<Up>", "<Right>" }) do
  vim.keymap.set({ "n", "v", "i" }, arrow, "<Nop>", {
    noremap = true,
    silent = true,
  })
end

-- Join lines witout moving cursor to the middle
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without jump" })

-- Redo with U
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Jump between errors only ([d and ]d cover all severities)
local function diagnostic_jump(count)
  return function()
    vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity.ERROR })
  end
end

vim.keymap.set("n", "[e", diagnostic_jump(-1), { desc = "Previous Error" })
vim.keymap.set("n", "]e", diagnostic_jump(1), { desc = "Next Error" })
