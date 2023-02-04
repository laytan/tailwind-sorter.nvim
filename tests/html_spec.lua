local tailwind_sorter = require('tailwind-sorter')

describe(
  'test html', function()
    local files = { './tests/test.html', './tests/test_weird_spacing.html' }

    for _, file in ipairs(files) do
      it(
        string.format('correctly sorts "%s"', file), function()
          assert.same(
            1, vim.fn.filereadable(file),
            string.format('File "%s" not readable', file)
          )

          vim.cmd(string.format('edit %s', file))

          local received = {}
          local description = ''
          local expected = {}

          local co = coroutine.running()
          tailwind_sorter.sort(
            0, function()
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

              for i = 1, math.floor(#lines / 2) - 1 do
                table.insert(received, lines[i])
              end

              description = lines[math.ceil(#lines / 2)]:sub(6)

              for i = math.ceil(#lines / 2) + 1, #lines - 1 do
                table.insert(expected, lines[i])
              end

              coroutine.resume(co)
            end
          )
          coroutine.yield()

          assert.same(
            expected, received, string.format(
              'File "%s" "%s": received and expected not the same', file,
              description
            )
          )
        end
      )
    end
  end
)
