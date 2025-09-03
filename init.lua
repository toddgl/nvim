
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

-- Load pylsp to enable the Ruff plugin
require("lspconfig").pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          formatEnabled = true,
          -- Other settings can be configured here
        },
      },
    },
  },
})

-- In your init.lua or lua/config/keymaps.lua

local menu = require("menu")
vim.keymap.set("n", "<C-m>", function()
  menu.open(require("menu_definitions").default) -- Replace with the path to your menu table
end, { noremap = true, silent = true })

-- Set up the which-key leader menu

local wk = require('which-key')

wk.add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true }, -- hide this keymap
  { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  }
})

