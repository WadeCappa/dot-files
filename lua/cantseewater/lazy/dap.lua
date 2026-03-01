local plugins = {

  { "nvim-neotest/nvim-nio" },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "delve" },
      handlers = {},
    },
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "✗", texthl = "DapBreakpointRejected" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

      vim.api.nvim_set_hl(0, "DapBreakpoint",          { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected",  { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, "DapStopped",             { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine",         { bg = "#2e3440" })

      vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "DAP: Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over,         { desc = "DAP: Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "DAP: Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out,          { desc = "DAP: Step out" })
      vim.keymap.set("n", "<leader>dq", dap.terminate,         { desc = "DAP: Terminate" })
      vim.keymap.set("n", "<leader>dr", dap.restart,           { desc = "DAP: Restart" })
      vim.keymap.set("n", "<leader>dp", dap.pause,             { desc = "DAP: Pause" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "DAP: Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, { desc = "DAP: Log point" })
      vim.keymap.set("n", "<leader>dx", dap.clear_breakpoints, { desc = "DAP: Clear breakpoints" })
      vim.keymap.set("n", "<leader>d.", dap.run_last,          { desc = "DAP: Run last" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks",      size = 0.30 },
              { id = "watches",     size = 0.15 },
            },
            size = 45,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 12,
            position = "bottom",
          },
        },
        floating = { border = "rounded" },
      })

      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
      vim.keymap.set("n", "<leader>de", function()
        dapui.eval(nil, { enter = true })
      end, { desc = "DAP: Evaluate expression" })
    end,
  },

  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    config = function()
      require("dap-go").setup()

      vim.keymap.set("n", "<leader>dgt", require("dap-go").debug_test,
        { desc = "DAP Go: Debug test under cursor" })
      vim.keymap.set("n", "<leader>dgT", require("dap-go").debug_last_test,
        { desc = "DAP Go: Re-run last test" })
    end,
  },

}

return plugins
