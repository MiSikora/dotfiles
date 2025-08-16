return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "css",
          "gitignore",
          "html",
          "javascript",
          "json",
          "lua",
          "typescript",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "toml",
          "yaml",
        },
        auto_install = false,
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 102400
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>ss",
            node_incremental = "<Leader>si",
            node_decremental = "<Leader>sd",
            scope_incremental = false,
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = true,
            keymaps = {
              ["af"] = {
                query = "@function.outer",
                desc = "Select around function",
              },
              ["if"] = {
                query = "@function.inner",
                desc = "Select inside function",
              },
              ["ac"] = {
                query = "@class.outer",
                desc = "Select around class",
              },
              ["ic"] = {
                query = "@class.inner",
                desc = "Select inside class",
              },
              ["as"] = {
                query = "@local.scope",
                query_group = "locals",
                desc = "Select around scope",
              },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "v",
              ["@class.outer"] = "<c-v>",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
