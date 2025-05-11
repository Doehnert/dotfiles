return {
  'nvim-neotest/neotest',
  dependencies = {
    'olimorris/neotest-phpunit',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local neotest = require 'neotest'

    neotest.setup {
      adapters = {
        require 'neotest-phpunit' {
          phpunit_cmd = function()
            -- Runs tests via Laravel Sail
            return { './vendor/bin/sail', 'phpunit', '--testdox' }
          end,
        },
      },
    }

    -- Keymaps
    local map = vim.keymap.set
    map('n', '<leader>tn', function()
      neotest.run.run()
    end, { desc = '[T]est [N]earest' })
    map('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = '[T]est [F]ile' })
    map('n', '<leader>tl', function()
      neotest.run.run_last()
    end, { desc = '[T]est [L]ast' })
    map('n', '<leader>to', function()
      neotest.output.open { enter = true }
    end, { desc = '[T]est [O]utput' })
    map('n', '<leader>ts', function()
      neotest.summary.toggle()
    end, { desc = '[T]est [S]ummary' })
  end,
}
