return {
  src = "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })
  end,
}
