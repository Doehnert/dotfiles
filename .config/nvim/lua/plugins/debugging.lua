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

    -- Python Adapter
    dap.adapters.python = {
      type = 'executable',
      command = vim.fn.system('poetry env info -p'):gsub('%s+$', '') .. '/bin/python',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}', -- This will debug the current file
        pythonPath = function()
          return os.getenv 'VIRTUAL_ENV' and os.getenv 'VIRTUAL_ENV' .. '/bin/python' or 'python'
        end,
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

    -- Step over
    vim.keymap.set('n', '<Leader>dn', function()
      require('dap').step_over()
    end, { desc = 'DAP: Step Over' })

    -- Step into
    vim.keymap.set('n', '<Leader>di', function()
      require('dap').step_into()
    end, { desc = 'DAP: Step Into' })

    -- Step out
    vim.keymap.set('n', '<Leader>do', function()
      require('dap').step_out()
    end, { desc = 'DAP: Step Out' })

    -- Set conditional breakpoint
    vim.keymap.set('n', '<Leader>dT', function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'DAP: Conditional Breakpoint' })

    -- Run to cursor
    vim.keymap.set('n', '<Leader>dr', function()
      require('dap').run_to_cursor()
    end, { desc = 'DAP: Run to Cursor' })

    -- Open REPL
    vim.keymap.set('n', '<Leader>de', function()
      require('dap').repl.open()
    end, { desc = 'DAP: REPL Open' })

    -- Evaluate expression under cursor (useful in visual mode too)
    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
      require('dap.ui.widgets').hover()
    end, { desc = 'DAP: Hover Inspect' })
  end,
}
