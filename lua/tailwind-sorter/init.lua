local queries = require('nvim-treesitter.query')
local Job = require('plenary.job')
local util = require('tailwind-sorter.util')
local config = require('tailwind-sorter.config')

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
M.sort = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local matches = queries.get_capture_matches_recursively(
    buf, '@tailwind', 'tailwind'
  )

  local nodes = {}
  local texts = {}
  for _, match in ipairs(matches) do
    local node = match['node']
    local text = vim.treesitter.query.get_node_text(node, 0)

    table.insert(nodes, node)
    table.insert(texts, text)
  end

  if #nodes == 0 then
    return
  end

  local result = Job:new(
    {
      command = 'deno',
      args = {
        'run',
        '--allow-env',
        '--allow-read',
        util.plugin_path() .. '/formatter/src/index.ts',
        vim.json.encode(texts),
      },
    }
  ):sync()

  local out = vim.json.decode(result[1])

  -- Iterate the replacements in reverse and set them in the buffer.
  for i = #out, 1, -1 do
    util.replace_node_text(buf, nodes[i], out[i])
  end
end

M.toggle_on_save = function(extra_cfg)
  local cfg = M.config:with(extra_cfg)

  if M.augroup == nil then
    vim.notify(
      'The plugin is not setup yet, please call .setup() first.',
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
