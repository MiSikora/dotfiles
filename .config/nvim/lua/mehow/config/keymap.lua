vim.g.mapleader = " "

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<CR>", { noremap = true, silent = true })

-- Remove <Space>, <Backspace>, and <Enter> navigation
for _, key in ipairs({ "<Space>", "<BS>", "<CR>" }) do
	map({ "n", "v" }, key, "<Nop>", { noremap = true, silent = true })
end

-- Remove arrow navigation
for _, arrow in ipairs({ "<Left>", "<Down>", "<Up>", "<Right>" }) do
	map({ "n", "v", "i" }, arrow, "<Nop>", { noremap = true, silent = true })
end

-- Keep cursor's position
map("n", "J", "mzJ`z")
