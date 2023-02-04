local M = {}

--- @class CheckSortOptions
--- @field assert_unsorted boolean
--- @endclass

--- @param file string
--- @param opts nil|CheckSortOptions
M.check_sort = function(file, opts)
  local options = opts or {}
  local assert_unsorted = options.assert_unsorted or false

  local received = {}
  local description = ''
  local expected = {}

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for i = 1, math.floor(#lines / 2) - 1 do
    table.insert(received, lines[i])
  end

  description = lines[math.ceil(#lines / 2)]:sub(6)

  for i = math.ceil(#lines / 2) + 1, #lines - 1 do
    table.insert(expected, lines[i])
  end

  if assert_unsorted then
    assert.Not.same(
      expected, received, string.format(
        'File "%s" "%s": file has been sorted, but it shouldn\'t be', file,
        description
      )
    )
  else
    assert.same(
      expected, received, string.format('File "%s" "%s": ', file, description)
    )
  end
end

--- @param file string
M.open = function(file)
  assert.same(
    1, vim.fn.filereadable(file), string.format('File "%s" not readable', file)
  )

  vim.cmd(string.format('edit! %s', file))
end

return M
