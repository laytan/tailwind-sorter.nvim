local common = require('tests.common')

describe(
  'with custom configuration', function()
    it(
      'supports custom configuration', function()
        local file = './tests/fixtures/configured/test.html'
        vim.cmd('cd ./tests/fixtures/configured')
        common.open(file)

        require('tailwind-sorter').setup().sort()

        common.check_sort(file)
      end
    )
  end
)
