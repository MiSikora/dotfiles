return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
      },
      extensions = {
        fzf = {},
      },
    })
    telescope.load_extension("fzf")

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { desc = "Telescope: " .. desc })
    end
    local builtin = require("telescope.builtin")
    map("<leader>ff", builtin.find_files, "[F]ind [F]iles")
    map("<leader>fh", builtin.help_tags, "[F]ind [H]elp")
    map("<leader>fg", builtin.live_grep, "[F]ind [G]rep")
    map("<leader>fs", builtin.grep_string, "[F]ind [S]tring")
  end,
}
