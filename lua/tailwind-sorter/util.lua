local M = {}

--- @return string
M.plugin_path = function()
  return debug.getinfo(1).source:sub(2, -10) .. '/../..'
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

--- @param buf integer
--- @param node userdata
--- @param text string|table
M.replace_node_text = function(buf, node, text)
  if type(text) == 'string' then
    text = M.split_lines(text)
  end

  local srow, scol, erow, ecol = node:range()
  vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, text)
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
