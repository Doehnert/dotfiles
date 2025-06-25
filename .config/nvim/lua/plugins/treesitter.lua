return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  config = function()
    -- Register the custom blade parser from EmranMR/tree-sitter-blade
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = 'https://github.com/EmranMR/tree-sitter-blade', -- repo of the custom parser
        files = { 'src/parser.c' },
        branch = 'main',
      },
      filetype = 'blade', -- important for filetype detection
    }

    -- Setup nvim-treesitter with your options
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'lua',
        'python',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'regex',
        'terraform',
        'sql',
        'dockerfile',
        'toml',
        'json',
        'java',
        'groovy',
        'go',
        'gitignore',
        'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'php',
        'tsx',
        'css',
        'html',
        'blade',
      },
      auto_install = true,
      fold = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    }
  end,
}
