-- Disable vertical guide lines
vim.opt_local.colorcolumn = ""

-- Disable the banner
vim.g.netrw_banner = 0

-- Show line numbers
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- Hide curent and parent directories
vim.g.netrw_list_hide = [[^./$,^../$]]
