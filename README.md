# Tailwind Sorter for Neovim

Sorts your tailwind classes, just like
[prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss).

The plugin integrates with Treesitter to find classes. This means it can work in
any language and is easy to extend to new file types.

## Features

- Works in more file types than prettier does (using a treesitter integration),
  confirmed to work with:
  - jsx
  - tsx
  - html
  - twig
  - handlebars
  - any languages that inject any of the above languages
- Not having to pull in prettier just to have your classes sorted
- Easier/faster than prettier if all you want is tailwind sorting
- Easy to extend to other languages or use-cases

## Usage

### Commands

- `:TailwindSort` sorts classes in the current buffer
- `:TailwindSortOnSaveToggle` toggles automatic sorting on save

### Requirements

- NodeJS, tested with v16
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [plenary](https://github.com/nvim-lua/plenary.nvim)

### Configuration

The following is the **default** configuration:

```lua
require('tailwind-sorter').setup({
  on_save_enabled = false, -- If `true`, automatically enables on save sorting.
  on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php' }, -- The file patterns to watch and sort.
  node_path = 'node',
})
```

#### lazy.nvim

```lua
require('lazy').setup({
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = {'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim'},
    build = 'cd formatter && npm i && npm run build',
    config = {},
  },
})
```

#### packer.nvim

```lua
require('packer').startup(function(use)
  use {
    'laytan/tailwind-sorter.nvim',
    requires = {'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim'},
    config = function() require('tailwind-sorter').setup() end,
    run = 'cd formatter && npm i && npm run build',
  }
end)
```

#### vim-plug

```vim
call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'laytan/tailwind-sorter.nvim', { 'do': 'cd formatter && npm i && npm run build' }

call plug#end()

lua <<EOF
  require('tailwind-sorter').setup()
EOF
```

### Extending

I strongly recommend reading `:h treesitter-query` before doing this.

**TLDR**: tailwind-sorter.nvim looks for `tailwind.scm` files in your `queries`
directory and sorts any `@tailwind` captures. Make sure to add them to the
`on_save_pattern` config if you use the on save sort feature.

Here is how you would add support for jsx syntax (if it was not added already):

1. Create the file `queries/javascript/tailwind.scm`
2. We will paste the following to target any string inside the className
   attribute:

```query
(jsx_attribute
  (property_identifier) @_name
    (#eq? @_name "className")
  (string
    (string_fragment) @tailwind))
```

3. Add any file extension for jsx in the `on_save_pattern` config:

```lua
require('tailwind-sorter').setup({
  on_save_pattern = { '*.html', '*.jsx', '*.tsx' },
})
```

_Please consider PR'ing this extension back to the plugin._
