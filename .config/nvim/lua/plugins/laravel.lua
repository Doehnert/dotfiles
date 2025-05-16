return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv', -- Optional: for loading .env files
      'MunifTanjim/nui.nvim',
      'kevinhwang91/promise-async', -- Required: Promise-async for laravel.nvim
    },
    ft = { 'php', 'blade' },
    cmd = { 'Artisan', 'Laravel' },
    config = function()
      require('laravel').setup()
    end,
  },
}
