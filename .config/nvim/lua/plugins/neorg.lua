return {
  'nvim-neorg/neorg',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = ':Neorg sync-parsers',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/neorg/notes',
            },
            default_workspace = 'notes',
          },
        },
        ['core.keybinds'] = {
          config = {
            default_keybinds = true,
            neorg_leader = '<Leader>o',
          },
        },
      },
    }
  end,
}
