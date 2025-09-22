-- File: lua/lsp-config/nvim-lspconfig.lua (Lazy.nvim style)
-- Goal: Start simple with Python via pylsp + Ruff, and leave clean toggles/placeholders
--       for occasional JS/TS, HTML/CSS, and PHP work.
--
-- Prereqs (install in your system or the same Python env as pylsp):
--   Python: python-lsp-server (pylsp) + python-lsp-ruff + ruff
--     e.g. with pip/pipx:  pipx install python-lsp-server python-lsp-ruff ruff
--     (On FreeBSD, packages are usually under /usr/local; ensure ruff is on PATH.)
--   JS/TS (when you enable it below): npm i -g typescript typescript-language-server
--   HTML/CSS (when you enable it below): npm i -g vscode-langservers-extracted
--
-- Using vim.lsp.config (new recommended API)
-- Goal: Modern LSP setup using vim.lsp.start() (no lspconfig dependency for setup)
-- Works with pylsp + Ruff by default, with toggles/placeholders for other languages.
-- Adds executable checks so missing servers are skipped gracefully.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -------------------------------------------------------------------------
      -- Ensure /usr/local/bin is in PATH (important on FreeBSD GUI sessions)
      -------------------------------------------------------------------------
      if not string.find(vim.env.PATH or "", "/usr/local/bin", 1, true) then
        vim.env.PATH = "/usr/local/bin:" .. (vim.env.PATH or "")
      end

      -------------------------------------------------------------------------
      -- Capabilities (with cmp_nvim_lsp if available)
      -------------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp.default_capabilities(capabilities)
      end

      -------------------------------------------------------------------------
      -- on_attach: Keymaps + format-on-save
      -------------------------------------------------------------------------
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
          if vim.g.format_on_save_python ~= false and client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
              end,
            })
          end
        end
      end

      -------------------------------------------------------------------------
      -- Toggle command for Python format-on-save
      -------------------------------------------------------------------------
      vim.api.nvim_create_user_command("FormatOnSavePythonToggle", function()
        vim.g.format_on_save_python = not vim.g.format_on_save_python
        vim.notify("Python format-on-save: " .. (vim.g.format_on_save_python and "ON" or "OFF"))
      end, {})

      -------------------------------------------------------------------------
      -- Warn if Ruff is missing
      -------------------------------------------------------------------------
      if vim.fn.executable("ruff") ~= 1 then
        vim.notify("[pylsp-ruff] 'ruff' not found in $PATH", vim.log.levels.WARN)
      end

      -------------------------------------------------------------------------
      -- Helper: Start an LSP server using vim.lsp.start(), skipping if missing
      -------------------------------------------------------------------------
      local function setup_server(name, opts)
        local binary = opts.cmd and opts.cmd[1] or name
        if vim.fn.executable(binary) ~= 1 then
          vim.notify(
            string.format("[LSP] Skipping %s (executable not found: %s)", name, binary),
            vim.log.levels.WARN
          )
          return
        end

        local config = {
          name = name,
          cmd = opts.cmd or { name },
          root_dir = opts.root_dir or vim.fs.root(0, { ".git", "pyproject.toml" }),
          settings = opts.settings,
          capabilities = capabilities,
          on_attach = on_attach,
        }
        vim.lsp.start(config)
      end

      -------------------------------------------------------------------------
      -- Stage 1: Python + Ruff
      -------------------------------------------------------------------------
      setup_server("pylsp", {
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
      })

      -------------------------------------------------------------------------
      -- Stage 2: JS/TS (enable when needed)
      -------------------------------------------------------------------------
      local enable_js_ts = false
      if enable_js_ts then
        setup_server("tsserver", {})
      end

      -------------------------------------------------------------------------
      -- Stage 3: HTML/CSS (enable when needed)
      -------------------------------------------------------------------------
      local enable_html_css = true
      if enable_html_css then
        setup_server("html", {})
        setup_server("cssls", {})
      end

      -------------------------------------------------------------------------
      -- Stage 4: PHP (enable when needed)
      -------------------------------------------------------------------------
      local enable_php = false
      if enable_php then
        setup_server("intelephense", {})
      end

      -------------------------------------------------------------------------
      -- Stage 5: Bash
      -------------------------------------------------------------------------
      setup_server("bashls", {})

      -------------------------------------------------------------------------
      -- Diagnostics config
      -------------------------------------------------------------------------
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
