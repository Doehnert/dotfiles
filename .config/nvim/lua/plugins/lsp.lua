return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
          require('mason-lspconfig').setup {
            -- ensure_installed = { 'intelephense', 'pylsp', 'omnisharp' },
            ensure_installed = { 'phpactor', 'pylsp', 'omnisharp' },
            automatic_installation = true,
          }
        end,
      },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
          'williamboman/mason.nvim',
          'williamboman/mason-lspconfig.nvim',
        },
      },
      { 'j-hui/fidget.nvim',       opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- LSP keymaps and attach logic
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-php', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', function()
            require('telescope.builtin').treesitter()
          end, '[D]ocument [S]ymbols via Treesitter')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- -- PHP (Intelephense)
      -- require('lspconfig').intelephense.setup {
      --   capabilities = capabilities,
      --   settings = {
      --     intelephense = {
      --       environment = {
      --         includePaths = { 'vendor' },
      --       },
      --       files = {
      --         maxSize = 5000000,
      --         associations = { '**/*.php' },
      --         exclude = {},
      --       },
      --       diagnostics = {
      --         enable = true,
      --       },
      --     },
      --   },
      -- }

      -- PHP (Phpactor)
      require('lspconfig').phpactor.setup {
        capabilities = capabilities,
        init_options = {
          ['language_server_phpstan.enabled'] = false,
          ['language_server_psalm.enabled'] = false,
        },
      }

      -- Python (pylsp)
      require('lspconfig').pylsp.setup {
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
              pylint = { enabled = false },
            },
          },
        },
      }

      -- C# / .NET
      local omnisharp_bin = vim.fn.stdpath 'data' .. '/mason/bin/OmniSharp'

      require('lspconfig').omnisharp.setup {
        cmd = { omnisharp_bin, '-z', '--hostPID', tostring(vim.fn.getpid()) },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Disable semantic tokens if you want, or customize here
          client.server_capabilities.semanticTokensProvider = nil
        end,
      }
    end,
  },
}
