# Tailwind Sorter for Neovim

Sorts your tailwind classes, just like
[prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss).

The plugin currently works in the treesitter parsers `html_tags` and `jsx`, and
is very easy to extend (see below). This means it should work in any language
that extends/injects html or jsx.

## Features

- Works in more file types than prettier does (using a treesitter integration),
  confirmed to work with:
  - jsx
  - tsx
  - html
  - twig
  - handlebars
- Not having to pull in prettier just to have your classes sorted
- Easier/faster than prettier

## Usage

### Commands

- `:TailwindSort` sorts classes in the current buffer
- `:TailwindSortOnSaveToggle` toggles automatic sorting on save

### Configuration

The following is the **default** configuration:

```lua
require('tailwind-sorter').setup({
  on_save_enabled = false, -- If `true`, automatically enables on save sorting.
  on_save_pattern = { '*.html', '*.js', '*.jsx', '*.tsx', '*.twig', '*.hbs' }, -- The file patterns to watch and sort.
})
```

#### lazy.nvim

```lua
require('lazy').setup({
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = {'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim'},
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
  }
end)
```

#### vim-plug

```vim
call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'laytan/tailwind-sorter.nvim'

call plug#end()

lua <<EOF
  require('tailwind-sorter').setup()
EOF
```

### Requirements

- [deno](https://deno.land/manual@v1.30.2/getting_started/installation) (The
  deno requirement is temporary and will be dropped soon)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [plenary](https://github.com/nvim-lua/plenary.nvim)

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
