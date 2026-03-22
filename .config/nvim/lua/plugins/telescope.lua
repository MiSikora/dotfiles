local function parse_projects(output)
  local projects = {}

  for line in vim.gsplit(output, "\n", { plain = true, trimempty = true }) do
    local label, path = line:match("^(.-)\t(.*)$")

    if label and path then
      table.insert(projects, {
        label = vim.trim(label),
        path = path,
      })
    end
  end

  return projects
end

local function switch_project(script, project)
  if vim.env.TMUX and vim.env.TMUX ~= "" then
    vim.system({ script, "switch", project.path }, {}, function(result)
      if result.code ~= 0 then
        vim.schedule(function()
          local stderr = vim.trim(result.stderr or "")
          local message = stderr ~= "" and stderr or "tmux_session switch failed"
          vim.notify(message, vim.log.levels.ERROR)
        end)
      end
    end)

    return
  end

  vim.cmd("silent !" .. vim.fn.shellescape(script) .. " switch " .. vim.fn.shellescape(project.path))
end

local function open_tmux_session_picker()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local script = vim.fn.exepath("tmux_session")

  if script == "" then
    vim.notify("tmux_session is not available on PATH", vim.log.levels.ERROR)
    return
  end

  vim.system({ script, "list" }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local stderr = vim.trim(result.stderr or "")
        local message = stderr ~= "" and stderr or "tmux_session list failed"
        vim.notify(message, vim.log.levels.ERROR)
        return
      end

      local projects = parse_projects(result.stdout or "")

      if vim.tbl_isempty(projects) then
        vim.notify("No tmux_session projects found", vim.log.levels.ERROR)
        return
      end

      pickers
        .new({}, {
          prompt_title = "Tmux Session",
          layout_config = {
            width = 0.5,
            height = 0.5,
          },
          finder = finders.new_table({
            results = projects,
            entry_maker = function(project)
              return {
                value = project,
                display = project.label,
                ordinal = project.label,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              if selection then
                switch_project(script, selection.value)
              end
            end)

            return true
          end,
        })
        :find()
    end)
  end)
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
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
    }
  end,
  keys = function()
    local builtin = require("telescope.builtin")

    return {
      { "<leader>ff", builtin.find_files, desc = "Telescope: [F]ind [F]iles" },
      { "<leader>fh", builtin.help_tags, desc = "Telescope: [F]ind [H]elp" },
      { "<leader>fg", builtin.live_grep, desc = "Telescope: [F]ind [G]rep" },
      { "<leader>fs", builtin.grep_string, desc = "Telescope: [F]ind [S]tring" },
      { "<leader>ts", open_tmux_session_picker, desc = "Telescope: [T]mux [S]ession" },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    telescope.load_extension("fzf")
  end,
}
