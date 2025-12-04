return {
  "williamboman/mason.nvim",
  -- This plugin is brought in as a dependency of the debugging setup.
  -- We provide an explicit, empty configuration here to ensure it does not
  -- automatically install any LSPs. Our LSP setup is handled manually
  -- in the `lsp-config/nvim-lspconfig.lua` file, which uses the servers
  -- already installed on the system.
  opts = {
    ensure_installed = {},
  },
}
