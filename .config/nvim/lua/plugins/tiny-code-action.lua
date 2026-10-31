return {
  src = "rachartier/tiny-code-action.nvim",
  deps = {
    { src = "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("tiny-code-action").setup({
      picker = "telescope",
      backend = "delta",
      backend_opts = {
        delta = {
          args = {
            "--line-numbers",
            -- Ignore side-by-side from git config, it doesn't fit the preview pane
            "--no-gitconfig",
          },
        },
      },
    })
  end,
}
