-- File: lua/lsp-config/nvim-lspconfig.lua
-- Modern LSP setup using vim.lsp.start()
-- Declarative server table (Option 3)
-- Missing LSP executables are silently skipped

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -----------------------------------------------------------------------
      -- Ensure /usr/local/bin is in PATH (important on FreeBSD GUI sessions)
      -----------------------------------------------------------------------
      if not string.find(vim.env.PATH or "", "/usr/local/bin", 1, true) then
        vim.env.PATH = "/usr/local/bin:" .. (vim.env.PATH or "")
      end

      -----------------------------------------------------------------------
      -- Capabilities (with cmp_nvim_lsp if available)
      -----------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp.default_capabilities(capabilities)
      end

      -----------------------------------------------------------------------
      -- on_attach: Keymaps + format-on-save
      -----------------------------------------------------------------------
      local function on_attach(client, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>lf", function()
          vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
        end, "Format buffer")

        -- Python: format-on-save
        if vim.bo[bufnr].filetype == "python" then
          if vim.g.format_on_save_python ~= false
            and client.server_capabilities.documentFormattingProvider
          then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
              end,
            })
          end
        end
      end

      -----------------------------------------------------------------------
      -- Toggle command for Python format-on-save
      -----------------------------------------------------------------------
      vim.api.nvim_create_user_command("FormatOnSavePythonToggle", function()
        vim.g.format_on_save_python = not vim.g.format_on_save_python
        vim.notify(
          "Python format-on-save: "
            .. (vim.g.format_on_save_python and "ON" or "OFF")
        )
      end, {})

      -----------------------------------------------------------------------
      -- Helper: Start server if executable exists (silent skip)
      -----------------------------------------------------------------------
      local function start_server(name, opts)
        opts = opts or {}
        local binary = opts.cmd and opts.cmd[1] or name

        if vim.fn.executable(binary) ~= 1 then
          return
        end

        vim.lsp.start({
          name = name,
          cmd = opts.cmd or { name },
          root_dir = opts.root_dir
            or vim.fs.root(0, { ".git", "pyproject.toml" }),
          settings = opts.settings,
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      -----------------------------------------------------------------------
      -- Declarative LSP server table
      -----------------------------------------------------------------------
      local servers = {
        -------------------------------------------------------------------
        -- Python + Ruff (enabled by default)
        -------------------------------------------------------------------
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                black = { enabled = false },
                ruff = {
                  enabled = true,
                  formatEnabled = true,
                  lineLength = 88,
                },
              },
            },
          },
        },

        -------------------------------------------------------------------
        -- Bash
        -------------------------------------------------------------------
        bashls = {},

        -------------------------------------------------------------------
        -- HTML / CSS
        -------------------------------------------------------------------
        html = {},
        cssls = {},

        -------------------------------------------------------------------
        -- YAML
        -------------------------------------------------------------------
        yamlls = {
          cmd = { "yaml-language-server", "--stdio" },
          settings = {
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              hover = true,
              completion = true,
              schemas = {
                kubernetes = "/*.k8s.yaml",
                ["http://json.schemastore.org/github-workflow"]
                  = "/.github/workflows/*",
                ["http://json.schemastore.org/github-action"]
                  = "/.github/action.{yml,yaml}",
                ["http://json.schemastore.org/docker-compose"]
                  = "docker-compose*.{yml,yaml}",
              },
            },
          },
        },

        -------------------------------------------------------------------
        -- Optional / disabled by default (uncomment when needed)
        -------------------------------------------------------------------
        -- tsserver = {},
        -- intelephense = {},
      }

      -----------------------------------------------------------------------
      -- Start all declared servers
      -----------------------------------------------------------------------
      for name, opts in pairs(servers) do
        start_server(name, opts)
      end

      -----------------------------------------------------------------------
      -- Diagnostics
      -----------------------------------------------------------------------
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}
