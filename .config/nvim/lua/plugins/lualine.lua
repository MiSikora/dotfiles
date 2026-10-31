return {
  src = "nvim-lualine/lualine.nvim",
  deps = {
    { src = "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-nvim",
        refresh = {
          statusline = 8,
        },
        disabled_filetypes = { "no-neck-pain" },
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
              modifed = "",
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
