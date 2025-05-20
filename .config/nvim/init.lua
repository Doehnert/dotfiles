require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_set_keymap(
  'n',                          -- normal mode
  '<Leader>on',                 -- your chosen keybinding (o = neorg leader, n = open notes)
  ':Neorg workspace notes<CR>', -- Neorg command to open your "notes" workspace
  { noremap = true, silent = true }
)

-- Set up plugins
require('lazy').setup {
  require 'plugins.neotree',
  require 'plugins.colortheme',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.gitsigns',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.misc',
  require 'plugins.snacks',
  require 'plugins.neotest-phpunit',
  require 'plugins.debugging',
  require 'plugins.codecompanion',
  require 'plugins.flash',
  require 'plugins.surround',
  require 'plugins.fzf',
  require 'plugins.laravel',
  require 'plugins.neorg',
  require 'plugins.oil',
  require 'plugins.notify',
  require 'plugins.namespace'
}
