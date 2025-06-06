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

      local gdb_path = os.getenv("GDB_PATH")
      if not gdb_path or gdb_path == "" then
        if vim.fn.has('win32') == 1 then
          gdb_path = "C:/mingw64/bin/gdb.exe"
        else
          gdb_path = "gdb"
        end
      end

      dap.adapters.gdb = {
        type = "executable",
        command = gdb_path,
        args = { "-i=mi" },
        options = { detached = false, virt_text_pos = 'eol' }
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "gdb",
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
