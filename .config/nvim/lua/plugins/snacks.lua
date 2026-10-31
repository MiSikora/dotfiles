return {
  src = "folke/snacks.nvim",
  priority = 1000,
  config = function()
    require("snacks").setup({
      bigfile = {},
      input = {},
      quickfile = {},
      styles = {
        input = {
          relative = "cursor",
        },
      },
    })
  end,
}
