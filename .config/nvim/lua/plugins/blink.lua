return {
  src = "saghen/blink.cmp",
  version = vim.version.range("1.*"),
  deps = {
    {
      src = "L3MON4D3/LuaSnip",
      version = vim.version.range("2.*"),
      build = "make install_jsregexp",
      deps = {
        { src = "rafamadriz/friendly-snippets" },
      },
    },
    { src = "folke/lazydev.nvim" },
  },
  config = function()
    require("luasnip").setup()
    require("luasnip.loaders.from_vscode").lazy_load()

    require("blink.cmp").setup({
      keymap = { preset = "enter" },
      snippets = { preset = "luasnip" },
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
