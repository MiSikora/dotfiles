vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })
