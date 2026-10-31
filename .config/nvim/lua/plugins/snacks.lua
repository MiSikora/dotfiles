return {
  src = "folke/snacks.nvim",
  priority = 1000,
  config = function()
    require("snacks").setup({
      input = {},
      styles = {
        input = {
          relative = "cursor",
        },
      },
    })
  end,
}
