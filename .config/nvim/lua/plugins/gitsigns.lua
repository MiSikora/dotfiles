return {
  src = "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      -- Dotfiles live in a bare repo with $HOME as the work tree
      worktrees = {
        {
          toplevel = vim.env.HOME,
          gitdir = vim.env.DOTFILES_GIT,
        },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, {
            buffer = bufnr,
            desc = "Git: " .. desc,
            noremap = true,
            silent = true,
          })
        end

        -- Navigation (fall back to builtin behaviour in diff mode)
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Next Hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Previous Hunk")

        -- Hunks
        map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Selection")
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Selection")
        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Preview Hunk")

        -- Blame and diff
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff Against Index")
        map("n", "<leader>gq", gitsigns.setqflist, "Hunks To Quickfix")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
      end,
    })
  end,
}
