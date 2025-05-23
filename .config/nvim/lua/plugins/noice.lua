return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify', -- optional, for enhanced notifications
  },
  config = function()
    require('noice').setup()
  end,
}
