return {
  src = "saghen/blink.cmp",
  version = vim.version.range("1.*"),
  deps = {
    { src = "rafamadriz/friendly-snippets" },
    { src = "folke/lazydev.nvim" },
  },
  config = function()
    require("blink.cmp").setup({
      keymap = { preset = "enter" },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    })
  end,
}
