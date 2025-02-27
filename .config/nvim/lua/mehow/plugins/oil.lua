return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Lazy loading is not recommended because it is very tricky
  -- to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".."
        end,
      },
    })
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Oil: Open explorer" })
  end,
}
