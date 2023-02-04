local common = require('tests.common')
local tailwind_sorter = require('tailwind-sorter').setup()

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

          tailwind_sorter.sort()

          common.check_sort(file)
        end
      )
    end
  end
)
