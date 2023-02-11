local Job = require('plenary.job')
local config = require('tailwind-sorter.config')
local util = require('tailwind-sorter.util')
local tsutil = require('tailwind-sorter.tsutil')

local M = {}

--- @type nil|integer
M.augroup = nil
M.config = config:with()
M.on_save_enabled = false

--- @param cfg TWPartialConfig
M.setup = function(cfg)
  M.config:apply(cfg)

  M.deno_cache()

  M.augroup = vim.api.nvim_create_augroup('tailwind-sorter', {})

  vim.api.nvim_create_user_command(
    'TailwindSort', function()
      M.sort()
    end, {}
  )

  vim.api.nvim_create_user_command(
    'TailwindSortOnSaveToggle', function()
      M.toggle_on_save()
    end, {}
  )

  if M.config:get().on_save_enabled then
    M.toggle_on_save()
  end

  return M
end

--- @param buf nil|integer
--- @param extra_cfg nil|TWPartialConfig
M.sort = function(buf, extra_cfg)
  local cfg = M.config
  if extra_cfg then
    cfg = cfg:with(extra_cfg)
  end

  buf = buf or vim.api.nvim_get_current_buf()

  local matches = tsutil.get_query_matches(buf)

  local texts = {}
  for _, match in ipairs(matches) do
    local text = tsutil.get_match_text(match)
    table.insert(texts, text)
  end

  if #texts == 0 then
    return
  end

  local plugin_path = util.plugin_path()
  local deno_path = cfg:get().deno_path

  local job = Job:new(
    {
      command = deno_path,
      args = {
        'run',
        '--no-config',
        '--quiet',
        '--allow-env',
        -- Tailwind reads and walks a bunch of files to retrieve your config.
        '--allow-read',
        -- Tailwind uses the uid (username) to retrieve configuration.
        '--allow-sys=uid',
        plugin_path .. '/formatter/src/index.ts',
        vim.json.encode(texts),
      },
    }
  )

  local result = job:sync()
  local error = job:stderr_result()

  if #error > 0 then
    vim.notify(
      '[tailwind-sorter.nvim]: Error during class sorting: ' ..
      table.concat(error, ', ') .. '.', vim.log.levels.ERROR
    )
    return
  end

  if #result ~= 1 then
    vim.notify(
      '[tailwind-sorter.nvim]: Unfortunately, no output has been received from the class sorting process.',
      vim.log.levels.ERROR
    )
  end

  local out = vim.json.decode(result[1])

  -- Iterate the replacements in reverse and set them in the buffer.
  for i = #out, 1, -1 do
    tsutil.put_new_node_text(matches[i], out[i])
  end
end

--- @param extra_cfg nil|TWPartialConfig
M.toggle_on_save = function(extra_cfg)
  local cfg = M.config
  if extra_cfg then
    cfg = cfg:with(extra_cfg)
  end

  if M.augroup == nil then
    vim.notify(
      '[tailwind-sorter.nvim]: The plugin is not setup yet, please call .setup() first.',
      vim.log.levels.ERROR
    )
  end

  if M.on_save_enabled then
    vim.api.nvim_clear_autocmds({ group = M.augroup })

    M.on_save_enabled = false
  else
    vim.api.nvim_create_autocmd(
      'BufWritePre', {
      pattern = cfg:get().on_save_pattern,
      group = M.augroup,
      command = 'TailwindSort',
    }
    )

    M.on_save_enabled = true
  end
end

--- @param extra_cfg nil|TWPartialConfig
--- @param on_exit nil|function
M.deno_cache = function(extra_cfg, on_exit)
  local cfg = M.config
  if extra_cfg then
    cfg = cfg:with(extra_cfg)
  end

  on_exit = on_exit or function() end

  local plugin_path = util.plugin_path()
  local deno_path = cfg:get().deno_path

  Job:new(
    {
      command = deno_path,
      args = {
        'cache',
        '--no-config',
        '--quiet',
        plugin_path .. '/formatter/src/index.ts',
      },
      on_exit = on_exit,
    }
  ):start()
end

return M
