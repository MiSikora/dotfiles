return {
  "nvim-lualine/lualine.nvim",
  dependecies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local flavour = require("catppuccin").flavour
    local palette = require("catppuccin.palettes").get_palette(flavour)
    local lazy_status = require("lazy.status")

    require("lualine").setup({
      options = {
        theme = "catppuccin",
        refresh = {
          statusline = 8,
        },
      },
      sections = {
        lualine_b = { "branch", "diagnostics" },
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
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = palette.peach },
          },
          { "encoding" },
          { "filetype" },
        },
      },
    })
  end,
}
