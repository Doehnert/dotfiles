return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local helpers = require 'null-ls.helpers'
    local extras = require 'none-ls.diagnostics.ruff'     -- for diagnostics
    local ruff_format = require 'none-ls.formatting.ruff' -- for formatting

    -- Ensure required tools are installed via mason
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier',  -- JavaScript/TypeScript
        'stylua',    -- Lua
        'eslint_d',  -- JS/TS linter
        'shfmt',     -- Shell
        'checkmake', -- Makefiles
        'ruff',      -- Python
        'csharpier', -- C#
      },
      automatic_installation = true,
    }

    -- Register Laravel Pint manually
    null_ls.register {
      name = 'pint',
      method = require('null-ls').methods.FORMATTING,
      filetypes = { 'php' },
      generator = require('null-ls.helpers').formatter_factory {
        command = 'pint',
        args = function(params)
          return {
            '--quiet',
            '--no-interaction',
            '--silent',
            params.bufname,
          }
        end,
        to_stdin = true,
        ignore_stderr = true,
      },
    }

    -- Other built-in sources
    local sources = {
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      diagnostics.checkmake,
      extras.with { extra_args = { '--extend-select', 'I' } },
      ruff_format,
      formatting.csharpier,
    }

    -- Format-on-save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup {
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
