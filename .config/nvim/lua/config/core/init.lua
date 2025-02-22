require("config.core.options")
require("config.core.keymap")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  desc = "Highlight text when yanking",
  callback = function()
    vim.highlight.on_yank()
  end,
})

