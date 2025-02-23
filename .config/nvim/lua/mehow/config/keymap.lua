vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("n", "<Space>", "<Nop>", { noremap = true, silent = true })
keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })
