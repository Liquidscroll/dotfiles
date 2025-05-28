return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      ui.setup()

      require("nvim-dap-virtual-text").setup({ commented = true })

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = "executable",
        command =
        "C:\\Users\\jojat\\.vscode\\extensions\\ms-vscode.cpptools-1.22.11-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe",
        options = { detached = false, virt_text_pos = 'eol' }
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
        },
      }

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

      vim.keymap.set("n", "<leader>?", function()
        ui.eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<M-1>", dap.continue)
      vim.keymap.set("n", "<M-2>", dap.step_into)
      vim.keymap.set("n", "<M-3>", dap.step_over)
      vim.keymap.set("n", "<M-4>", dap.step_out)
      vim.keymap.set("n", "<M-5>", dap.step_back)
      vim.keymap.set("n", "<M-0>", dap.restart)

      dap.listeners.before.attach.dapui_config = function() ui.open() end
      dap.listeners.before.launch.dapui_config = function() ui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() ui.open() end
      dap.listeners.before.event_exited.dapui_config = function() ui.open() end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies =
    { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
  }
}
