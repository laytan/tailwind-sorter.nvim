vim.opt.runtimepath:append('.')

vim.cmd('packadd nvim-treesitter')
vim.cmd('packadd plenary.nvim')

vim.cmd('TSUpdate')

vim.o.swapfile = false

require('nvim-treesitter.configs').setup(
  {
    ensure_installed = {
      'html',
      'javascript',
      'twig',
      'tsx',
      'glimmer',
      'heex',
      'elixir',
      'php',
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
    -- parser_install_dir = "/some/path/to/store/parsers",

    highlight = {
      -- `false` will disable the whole extension
      enable = true,
    },
  }
)
