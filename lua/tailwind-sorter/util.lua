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

--- @param buf number
--- @param node userdata
--- @param text string|table
M.replace_node_text = function(buf, node, text)
  if type(text) == 'string' then
    text = M.split_lines(text)
  end

  local srow, scol, erow, ecol = node:range()
  vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, text)
end

return M
