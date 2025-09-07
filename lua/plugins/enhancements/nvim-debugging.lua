-- file ~/.config/nvim/lua/plugins/enhancements/nvim-debugging.lua

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<leader>ds", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dT", function() require("dap").terminate() end, desc = "Terminate" },
    },
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = { auto_toggle = true },
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      {
        "<leader>du",
        function() require("dapui").toggle({}) end,
        desc = "Debug: Toggle UI",
      },
    },
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          handlers = {},
          automatic_installation = false,
          ensure_installed = {},
        },
        dependencies = {
          "mfussenegger/nvim-dap",
          "mason-org/mason.nvim",
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        lazy = true,
        config = function()
          local dap = require("dap")
          require("dap-python").setup("python")

          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              pythonPath = function()
                local venv_path = os.getenv("VIRTUAL_ENV")
                if venv_path then
                  return venv_path .. "/bin/python"
                end
                return "/usr/local/bin/python"
              end,
            },
          }
        end,
        dependencies = { "mfussenegger/nvim-dap" },
      },
      { "nvim-neotest/nvim-nio" },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true, -- inline virtual text
        dependencies = { "mfussenegger/nvim-dap" },
      },
    },
  },

  -- 🔥 Lualine integration for dap status + breakpoints
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = function(_, opts)
      local dap = require("dap")

      local function dap_status()
        return dap.status()
      end

      local function dap_breakpoints()
        local breakpoints = require("dap.breakpoints").get()
        local count = 0
        for _, buf_bps in pairs(breakpoints) do
          count = count + #buf_bps
        end
        if count > 0 then
          return " " .. count
        end
        return ""
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, dap_status)
      table.insert(opts.sections.lualine_x, dap_breakpoints)

      return opts
    end,
  },
}
