local M = {}

--- @return string
M.plugin_path = function()
  return vim.loop.fs_realpath(debug.getinfo(1).source:sub(2, -10) .. '/../..')
end

--- @param text string
--- @return string[]
M.split_lines = function(text)
  local lines = {}
  for line, _ in text:gsub('\r\n', '\n'):gmatch('([^\n]*)([\n]*)') do
    table.insert(lines, line)
  end
  table.remove(lines, #lines)

  return lines
end

--- @param obj table
--- @param seen nil|table
M.deep_copy = function(obj, seen)
  if type(obj) ~= 'table' then
    return obj
  end

  if seen and seen[obj] then
    return seen[obj]
  end

  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res

  for k, v in pairs(obj) do
    res[M.deep_copy(k, s)] = M.deep_copy(v, s)
  end

  return res
end

return M
