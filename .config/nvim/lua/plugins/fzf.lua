return {
  {
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = './install --bin',
      },
    },
    config = function() end,
  },
}
