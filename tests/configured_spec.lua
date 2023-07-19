local common = require('tests.common')

describe(
  'with custom configuration', function()
    it(
      'supports custom configuration', function()
        vim.cmd('edit! ./tailwind.config.js')
        vim.api.nvim_buf_set_lines(
          vim.api.nvim_get_current_buf(), 0, -1, false, {
            'module.exports = {',
            ' theme: {',
            '   extend: {',
            '     colors: {',
            '       gold: "#BEA042",',
            '     },',
            '   },',
            ' },',
            '};',
          }
        )
        vim.cmd(':w')

        local file = './tests/fixtures/configured/test.html'
        common.open(file)

        require('tailwind-sorter').setup().sort()
        common.check_sort(file)

        vim.cmd('!rm ./tailwind.config.js')
      end
    )

    it(
      'supports custom configuration using typescript', function()
        vim.cmd('edit! ./tailwind.config.ts')
        vim.api.nvim_buf_set_lines(
          vim.api.nvim_get_current_buf(), 0, -1, false, {
            'import { type Config } from "tailwindcss";',
            'export default {',
            ' theme: {',
            '   extend: {',
            '     colors: {',
            '       gold: "#BEA042",',
            '     },',
            '   },',
            ' },',
            '} satisfies Config;',
          }
        )
        vim.cmd(':w')

        local file = './tests/fixtures/configured/test.html'
        common.open(file)

        require('tailwind-sorter').setup().sort()
        common.check_sort(file)

        vim.cmd('!rm ./tailwind.config.ts')
      end
    )
  end
)
