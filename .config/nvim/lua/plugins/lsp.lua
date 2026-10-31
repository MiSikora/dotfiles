return {
  -- Only used for its lsp/*.lua server definitions
  src = "neovim/nvim-lspconfig",
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
    vim.lsp.enable("pylsp")
    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("tsc")
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

        -- Keep Neovim's default LSP keys (:help lsp-defaults) but route list
        -- results to Telescope and code actions to tiny-code-action for previews.
        -- Single-result keys (grn, grD, K, ...) stay builtin.
        map("gra", require("tiny-code-action").code_action, "Open Code Action")
        map("grr", telescope.lsp_references, "Goto References")
        map("gri", telescope.lsp_implementations, "Goto Implementation")
        map("grd", telescope.lsp_definitions, "Goto Definition")
        map("grt", telescope.lsp_type_definitions, "Goto Type Definition")
        map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
        map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
      end,
    })
  end,
}
