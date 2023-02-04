# Tailwind Sorter for Neovim

Sorts your tailwind classes, just like
[prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss).

## Features

- Works in more file types than prettier does (using a treesitter integration)
- Not having to pull in prettier just to have your classes sorted
- Easier/faster than prettier

## Usage

Once installed you can either use the `:TailwindSort` command or call it from
anywhere else:

```lua
-- Using a keymap.
vim.api.nvim_set_keymap('n', '<leader>ts', ':TailwindSort')

-- Using an auto command (format before saving).
local group = vim.api.nvim_create_augroup('tailwind-sorter', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {'*.html', '*.jsx' }, -- expand with other file types.
  command = 'TailwindSort',
  group = group,
})
```

### Requirements

- [deno](https://deno.land/manual@v1.30.2/getting_started/installation) (The
  deno requirement is temporary and will be dropped soon)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [plenary](https://github.com/nvim-lua/plenary.nvim)

### Installation

Any plugin manager will be able to install it but here is an example using
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
require('lazy').setup({
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = {'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim'},
    config = {},
    cmd = 'TailwindSort', -- Optional lazy loading.
  },
})
```

### Configuring and Extending

Coming soon
