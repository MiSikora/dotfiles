return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      float = {
        transparent = false,
        solid = false,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
