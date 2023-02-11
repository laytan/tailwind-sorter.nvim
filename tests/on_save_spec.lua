local common = require('tests.common')

describe(
  'test on save sort', function()

    it(
      'sorts .html on save with default config', function()
        local tailwind_sorter = require('tailwind-sorter')
        tailwind_sorter.setup()

        local file = './tests/fixtures/on_save/on_save_test.html'
        common.open(file)

        vim.cmd('TailwindSortOnSaveToggle')

        vim.cmd('doautocmd BufWritePre on_save_test.html')

        common.check_sort(file)

        vim.cmd('TailwindSortOnSaveToggle')
      end
    )

    it(
      'does not sort after toggling back off', function()
        local tailwind_sorter = require('tailwind-sorter')
        tailwind_sorter.setup()

        local file = './tests/fixtures/on_save/on_save_test.html'
        common.open(file)

        vim.cmd('TailwindSortOnSaveToggle')
        vim.cmd('TailwindSortOnSaveToggle')

        vim.cmd('doautocmd BufWritePre on_save_test.html')

        common.check_sort(file, { assert_unsorted = true })
      end
    )

    it(
      'sorts on save with overwritten pattern', function()
        local tailwind_sorter = require('tailwind-sorter')
        tailwind_sorter.setup()

        vim.api.nvim_create_autocmd(
          { 'BufEnter', 'BufWinEnter' },
          { pattern = '*.test', command = 'setfiletype html' }
        )

        local file = './tests/fixtures/on_save/on_save_test.test'
        common.open(file)

        tailwind_sorter.toggle_on_save(
          { on_save_pattern = { '*.html', '*.test' } }
        )

        vim.cmd('doautocmd BufWritePre on_save_test.test')

        common.check_sort(file)

        vim.cmd('TailwindSortOnSaveToggle')
      end
    )

    it(
      'can enable sort on save by default', function()
        local tailwind_sorter = require('tailwind-sorter')
        tailwind_sorter.setup({ on_save_enabled = true })

        local file = './tests/fixtures/on_save/on_save_test.html'
        common.open(file)

        vim.cmd('doautocmd BufWritePre on_save_test.html')

        common.check_sort(file)

        vim.cmd('TailwindSortOnSaveToggle')
      end
    )
  end
)
