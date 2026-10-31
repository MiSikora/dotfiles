vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("mehow/highlight_yank", { clear = true }),
  desc = "Highlight text when yanking",
  callback = function()
    vim.hl.on_yank()
  end,
})
