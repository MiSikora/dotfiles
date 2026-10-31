return {
  src = "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({
      -- Skip pairing inside strings and comments
      check_ts = true,
    })
  end,
}
