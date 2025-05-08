return {
  'nvim-neotest/neotest',
  dependencies = {
    'olimorris/neotest-phpunit',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-phpunit' {
          phpunit_cmd = function()
            return './vendor/bin/phpunit'
          end,
        },
      },
    }
  end,
}
