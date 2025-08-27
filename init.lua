

-- Load editor settings
require("configs.editor-settings")

-- Load keybindings
require("configs.keybindings")

-- Load plugin manager
require("plugins.manager.lazy")

-- Load corresponding LSP choosen by file extension
require("lspconfig").bashls.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").pyright.setup({})
