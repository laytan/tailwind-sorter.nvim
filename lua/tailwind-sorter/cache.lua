-- A basic cache implementation for our sorted classes.
-- This is to prevent building up a massive table over the course of an editing
-- session.

local M = {}

M.max_len = 500
M.chunk_size = 50
M.cache = {}

M.put = function (str)
  M.cache[str] = true

  if #M.cache > M.max_len then
    local removed = 0
    for k, _ in pairs(M.cache) do
      M.cache[k] = nil
      removed = removed + 1

      if removed > M.chunk_size then
        break
      end
    end
  end
end

M.has = function (str)
  return M.cache[str] ~= nil
end

return M
