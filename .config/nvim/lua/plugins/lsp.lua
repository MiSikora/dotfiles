return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.bashls.setup({})
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            -- Using stylua for formatting
            format = { enable = false },
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
      })
    end,
  },
}
