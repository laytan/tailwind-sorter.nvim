local common = require('tests.common')
local tailwind_sorter = require('tailwind-sorter').setup({ deno_cache = false })
local util = require('tailwind-sorter.util')

describe(
  '(automatic)', function()
    local files = util.split_lines(
      vim.fn.glob('./tests/fixtures/automatic/**/*')
    )

    for _, file in ipairs(files) do
      it(
        string.format('correctly sorts "%s"', file), function()
          common.open(file)
          tailwind_sorter.sort()
          common.check_sort(file)
        end
      )
    end
  end
)
