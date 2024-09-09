local Job = require('plenary.job')
local config = require('tailwind-sorter.config')
local util = require('tailwind-sorter.util')
local tsutil = require('tailwind-sorter.tsutil')
local sorted_cache = require('tailwind-sorter.cache')

local M = {}

--- @type nil|integer
M.augroup = nil
M.config = config:with()
M.on_save_enabled = false

--- @param cfg TWPartialConfig
M.setup = function(cfg)
  M.config:apply(cfg)

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

  local used_matches = {}
  local texts = {}
  for _, match in ipairs(matches) do
    local text = tsutil.get_match_text(match)

    if not sorted_cache.has(text) then
      table.insert(used_matches, match)
      table.insert(texts, text)
    end
  end

  if #texts == 0 then
    return
  end

  local plugin_path = util.plugin_path()
  local node_path = cfg:get().node_path

  local job = Job:new(
    {
      command = node_path,
      args = {
        plugin_path .. '/formatter/dist/index.js',
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

  -- Optionally trim extra spaces
  if cfg:get().trim_spaces then
    for i, class_string in ipairs(out) do
      out[i] = class_string:gsub("^%s*(.-)%s*$", "%1"):gsub("%s+", " ")
    end
  end

  -- Iterate the replacements in reverse and set them in the buffer.
  for i = #out, 1, -1 do
    sorted_cache.put(out[i])
    tsutil.put_new_node_text(used_matches[i], out[i])
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

return M
