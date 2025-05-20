return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup() -- Critical setup

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.after.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.after.event_exited.dapui_config = function()
      dapui.close()
    end

    dap.adapters.php = {
      type = 'executable',
      command = 'node',
      args = {
        os.getenv 'HOME' .. '/.local/share/nvim/dap/php-debug/out/phpDebug.js',
      },
    }

    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ['/var/www/html'] = '${workspaceFolder}',
        },
      },
    }

    local function has_config(name)
      for _, config in ipairs(dap.configurations.php) do
        if config.name == name then
          return true
        end
      end
      return false
    end

    if not has_config 'Listen for Xdebug' then
      table.insert(dap.configurations.php, {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ['/var/www/html'] = '${workspaceFolder}',
        },
      })
    end

    vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
    vim.keymap.set('n', '<Leader>dc', dap.continue, {})
    vim.keymap.set('n', '<Leader>dq', function()
      require('dapui').close()
    end, { desc = 'DAP UI: Close' })
  end,
}
