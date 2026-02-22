-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable 24-bit colors
vim.o.termguicolors = true

-- Share clipboard with the '+' register
vim.o.clipboard = "unnamedplus"

-- Disable swapfile and persist undofile
vim.o.swapfile = false
vim.o.undofile = true

-- Use an indentation of 2 spaces
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- Show whitespace
vim.opt.list = true
vim.opt.listchars = {
  tab = " »",
  nbsp = "␣",
}

-- Replace tab with spaces
vim.o.expandtab = true

-- Keep previous line indentation
vim.o.autoindent = true

-- Add automatic extra indentation for C-like constructs
vim.o.smartindent = true

-- Show line numbers
vim.o.number = true

-- Show line numbers relative to the current line
vim.o.relativenumber = true

-- Show sign column
vim.o.signcolumn = "yes"

-- Wrap long lines
vim.o.wrap = true

-- Keeps lines of context above/below the cursor while scrolling
vim.o.scrolloff = 10

-- Show vertical guide line
vim.o.colorcolumn = "141"

-- Highlight all matches when searching
vim.o.hlsearch = true

-- Highlight searches while typing
vim.o.incsearch = true

-- Make search case-insensitive
vim.o.ignorecase = true

-- Make search case-sensitive in case of mixed-case term
vim.o.smartcase = true

-- Trigger idle events faster
vim.o.updatetime = 300

-- Configure autocompletion
--   - Always show popup menu
--   - Do not select automatically
--   - Show at most 10 matches at once
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 15

-- Use rounded borders for floating windows
vim.opt.winborder = "rounded"

-- Display code diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})
