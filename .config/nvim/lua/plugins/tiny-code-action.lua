return {
  src = "rachartier/tiny-code-action.nvim",
  deps = {
    { src = "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("tiny-code-action").setup({
      picker = "telescope",
    })
  end,
}
