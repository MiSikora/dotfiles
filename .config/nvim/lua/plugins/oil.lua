return {
  src = "stevearc/oil.nvim",
  deps = {
    { src = "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".DS_Store"
        end,
      },
    })
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", {
      desc = "Oil: Open explorer",
    })

    -- Starting with a directory argument (e.g. `nvim .`) creates an oil buffer
    -- that a restored session (|:restart|) would try to create again (E95).
    vim.api.nvim_create_autocmd("SessionLoadPre", {
      group = vim.api.nvim_create_augroup("mehow/oil-session", { clear = true }),
      desc = "Drop oil buffers before a session recreates them",
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(buf):match("^oil://") then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
    })
  end,
}
