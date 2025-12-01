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
      vim.lsp.enable("bashls")
      vim.lsp.enable("cssls")
      vim.lsp.enable("eslint")
      vim.lsp.enable("html")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("lua_ls")
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            -- Using stylua for formatting
            format = { enable = false },
          },
        },
      })
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("tsgo")
      vim.lsp.enable("yamlls")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("mehow/lsp-attach", { clear = true }),
        callback = function(event)
          local telescope = require("telescope.builtin")

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
              buffer = event.buf,
              desc = "LSP: " .. desc,
              noremap = true,
              silent = true,
            })
          end

          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", require("tiny-code-action").code_action, "Open Code Action")
          map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
          map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
          map("grr", telescope.lsp_references, "[G]oto [R]eferences")
          map("gri", telescope.lsp_implementations, "[G]oto [I]mplementation")
          map("grd", telescope.lsp_definitions, "[G]oto [D]efinition")
          map("grt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local diagnostic_jump = function(count, severity)
            return function()
              vim.diagnostic.jump({ count = count, severity = severity })
            end
          end

          map("[d", diagnostic_jump(-1), "Previous Diagnostic")
          map("]d", diagnostic_jump(1), "Next Diagnostic")
          map("[e", diagnostic_jump(-1, vim.diagnostic.severity.ERROR), "Previous Error")
          map("]e", diagnostic_jump(1, vim.diagnostic.severity.ERROR), "Next Error")
        end,
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
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
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
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    opts = {
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
    },
  },
}
