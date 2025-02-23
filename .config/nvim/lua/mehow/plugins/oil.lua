return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Lazy loading is not recommended because it is very tricky
  -- to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open Oil file explorer" })
  end,
}
