local util = require('tailwind-sorter.util')

--- @class TWConfig
local M = {
  config = {
    on_save_enabled = false,
    on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php', '*.heex', '*.astro', '*.templ' },
    node_path = 'node',
  },
}

--- @class TWPartialConfig
--- @field on_save_enabled nil|boolean
--- @field on_save_pattern nil|string[]
--- @field node_path nil|string
--- @endclass

function M:get()
  return self.config
end

--- @param config nil|TWPartialConfig
function M:apply(config)
  if not config then
    return
  end

  self.config = vim.tbl_deep_extend('force', self.config, config)
end

--- @param config nil|TWPartialConfig
--- @return TWConfig
function M:with(config)
  local copy = util.deep_copy(self)
  if not config then
    return copy
  end

  copy:apply(config)

  return copy
end

return M
