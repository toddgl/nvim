
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

-- In your init.lua or lua/config/keymaps.lua
local menu = require("menu")
vim.keymap.set("n", "<C-m>", function()
  menu.open(require("menu_definitions").default) -- Replace with the path to your menu table
end, { noremap = true, silent = true })

