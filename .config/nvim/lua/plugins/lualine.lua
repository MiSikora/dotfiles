return {
  src = "nvim-lualine/lualine.nvim",
  deps = {
    { src = "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-nvim",
      },
      sections = {
        lualine_b = {
          "branch",
          "diagnostics",
        },
        lualine_c = {
          {
            "filename",
            symbols = {
              modified = "",
              readonly = "",
              unnamed = "",
            },
          },
        },
        lualine_x = {
          {
            "encoding",
          },
          {
            "filetype",
          },
        },
      },
    })
  end,
}
