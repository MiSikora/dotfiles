-- Plugin loader built on the native |vim.pack|.
--
-- Every file in lua/plugins/ (except this one) returns a plugin spec:
--
--   {
--     src = "owner/repo" | "https://...",  -- GitHub shorthand is expanded
--     name = "dir-name",                   -- optional, defaults to repo name
--     version = "tag" | vim.version.range, -- optional, defaults to default branch
--     deps = { spec, ... },                -- optional, same shape, added before this plugin
--     priority = 50,                       -- optional, higher configures first
--     build = "shell command" | function(path),  -- optional, runs on install/update
--     config = function() end,             -- optional, runs after all plugins are added
--   }

local function src_url(src)
  if src:find("://", 1, true) then
    return src
  end
  return "https://github.com/" .. src
end

local function spec_name(spec)
  return spec.name or spec.src:match("[^/]+$"):gsub("%.git$", "")
end

local function load_specs()
  local dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local plugins = {}

  for file, kind in vim.fs.dir(dir) do
    local module = file:match("^(.+)%.lua$")
    if kind == "file" and module and module ~= "init" then
      local plugin = require("plugins." .. module)
      plugin.priority = plugin.priority or 50
      plugin.__order = #plugins
      table.insert(plugins, plugin)
    end
  end

  table.sort(plugins, function(a, b)
    if a.priority ~= b.priority then
      return a.priority > b.priority
    end
    return a.__order < b.__order
  end)

  return plugins
end

local function collect(spec, pack_specs, builds, seen)
  for _, dep in ipairs(spec.deps or {}) do
    collect(dep, pack_specs, builds, seen)
  end

  local name = spec_name(spec)
  if seen[name] then
    return
  end
  seen[name] = true

  table.insert(pack_specs, {
    src = src_url(spec.src),
    name = name,
    version = spec.version,
  })

  if spec.build then
    builds[name] = spec.build
  end
end

local function run_build(build, path)
  if type(build) == "function" then
    build(path)
    return
  end

  local result = vim.system({ "sh", "-c", build }, { cwd = path }):wait()
  if result.code ~= 0 then
    vim.notify(("Build failed in %s:\n%s"):format(path, result.stderr), vim.log.levels.ERROR)
  end
end

local plugins = load_specs()
local pack_specs, builds, seen = {}, {}, {}

for _, plugin in ipairs(plugins) do
  collect(plugin, pack_specs, builds, seen)
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("mehow/pack-build", { clear = true }),
  desc = "Run plugin build steps after install or update",
  callback = function(event)
    local data = event.data
    local build = builds[data.spec.name]
    if build and (data.kind == "install" or data.kind == "update") then
      run_build(build, data.path)
    end
  end,
})

vim.pack.add(pack_specs, { confirm = false })

for _, plugin in ipairs(plugins) do
  if plugin.config then
    plugin.config()
  end
end

-- Dependency management commands

local function managed_names()
  return vim.tbl_map(function(plugin)
    return plugin.spec.name
  end, vim.pack.get(nil, { info = false }))
end

vim.api.nvim_create_user_command("DepsUpdate", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names)
end, {
  nargs = "*",
  complete = managed_names,
  desc = "Fetch plugin updates and review them before applying",
})

vim.api.nvim_create_user_command("DepsList", function()
  vim.pack.update(nil, { offline = true })
end, {
  desc = "Show installed plugins and their revisions",
})

vim.api.nvim_create_user_command("DepsClean", function()
  local unused = {}
  for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
    if not plugin.active then
      table.insert(unused, plugin.spec.name)
    end
  end

  if #unused == 0 then
    vim.notify("No unused plugins", vim.log.levels.INFO)
    return
  end

  vim.pack.del(unused)
  vim.notify("Removed: " .. table.concat(unused, ", "), vim.log.levels.INFO)
end, {
  desc = "Delete plugins that are no longer in the config",
})
