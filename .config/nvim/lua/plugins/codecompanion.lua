return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- Optional, for UI
  },
  opts = {
    provider = 'ollama',
    provider_options = {
      model = 'mistral', -- or llama3, gemma, etc.
    },
    prompts = {
      Explain = {
        prompt = 'Explain the following code:',
      },
      Refactor = {
        prompt = 'Refactor the following code to be cleaner and more efficient:',
      },
    },
  },
  keys = {
    {
      '<leader>cc',
      function()
        require('codecompanion').chat()
      end,
      desc = 'CodeCompanion Chat',
    },
    {
      '<leader>ca',
      function()
        require('codecompanion').actions()
      end,
      desc = 'CodeCompanion Actions',
    },
  },
}
