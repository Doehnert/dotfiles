return {
  'vim-test/vim-test',
  dependencies = {
    'tpope/vim-dispatch', -- optional, for async test running
  },
  config = function()
    vim.g['test#php#phpunit#executable'] = './vendor/bin/sail phpunit'
    -- Keymaps
    local map = vim.keymap.set
    map('n', '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [N]earest' })
    map('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [F]ile' })
    map('n', '<leader>tl', ':TestLast<CR>', { desc = '[T]est [L]ast' })
    map('n', '<leader>tv', ':TestVisit<CR>', { desc = '[T]est [V]isit' })
  end,
}
