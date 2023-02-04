local queries = require('nvim-treesitter.query')
local Job = require('plenary.job')
local util = require('tailwind-sorter.util')

local M = {}

-- TODO: configuration options.
M.setup = function()
  vim.api.nvim_create_user_command(
    'TailwindSort', function()
      M.sort()
    end, {}
  )
end

--- @param buf nil|number
--- @param on_done nil|function
M.sort = function(buf, on_done)
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
    if on_done then
      on_done()
    end
    return
  end

  Job:new(
    {
      command = 'deno',
      args = {
        'run',
        '--allow-env',
        '--allow-read',
        util.plugin_path() .. '/formatter/src/index.ts',
        vim.json.encode(texts),
      },
      on_exit = function(job)
        local out = vim.json.decode(job:result()[1])

        -- Iterate the replacements in reverse and set them in the buffer.
        vim.schedule(
          function()
            for i = #out, 1, -1 do
              util.replace_node_text(buf, nodes[i], out[i])
            end

            if on_done then
              on_done()
            end
          end
        )
      end,
    }
  ):start()
end

return M
