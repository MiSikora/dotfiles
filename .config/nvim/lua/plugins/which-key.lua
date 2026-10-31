return {
  src = "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      -- Show the panel only after the key timeout, not before
      delay = function()
        return vim.o.timeoutlen
      end,
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Tmux" },
      },
    })
  end,
}
