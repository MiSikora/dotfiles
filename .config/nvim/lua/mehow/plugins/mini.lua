return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    local trailspace = require("mini.trailspace")
    trailspace.setup()

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        trailspace.trim()
        trailspace.trim_last_lines()
      end,
    })

    require("mini.pairs").setup()
    require("mini.move").setup()
  end,
}
