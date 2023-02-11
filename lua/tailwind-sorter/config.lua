local util = require('tailwind-sorter.util')
local Job = require('plenary.job')

--- @class TWConfig
local M = {
  config = {
    on_save_enabled = false,
    on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php' },
    deno_path = 'deno',
  },
}

--- @class TWPartialConfig
--- @field on_save_enabled nil|boolean
--- @field on_save_pattern nil|string[]
--- @field deno_path nil|string
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

--- @return string|nil
function M:get_deno_path()
  local p = self:get().deno_path
  if p ~= 'deno' then
    return vim.loop.fs_realpath(p)
  end

  local out = Job:new({
    command = 'which',
    args = { 'deno' },
  }):sync()

  return out[1] or nil
end

return M
