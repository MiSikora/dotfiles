return {
  src = "jiaoshijie/undotree",
  deps = {
    { src = "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("undotree").setup()
    vim.keymap.set("n", "<leader>u", function()
      require("undotree").toggle()
    end, { desc = "Undotree: Toggle" })
  end,
}
