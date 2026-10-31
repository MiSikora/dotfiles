local languages = {
  "bash",
  "c",
  "css",
  "diff",
  "dockerfile",
  "gitcommit",
  "git_rebase",
  "groovy",
  "html",
  "java",
  "javascript",
  "json",
  "kotlin",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  src = "nvim-treesitter/nvim-treesitter",
  version = "main",
  -- Parsers must match the plugin revision, so update them whenever the plugin changes
  build = function()
    vim.cmd.packadd("nvim-treesitter")
    require("nvim-treesitter").update():wait(300000)
  end,
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()

    -- No-op when everything is already installed
    treesitter.install(languages)

    -- Zsh has no parser; the bash one is close enough
    vim.treesitter.language.register("bash", "zsh")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("mehow/treesitter", { clear = true }),
      desc = "Enable treesitter highlighting and indentation when a parser exists",
      callback = function(event)
        local language = vim.treesitter.language.get_lang(event.match)
        if not language or not vim.treesitter.language.add(language) then
          return
        end

        vim.treesitter.start(event.buf, language)
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
