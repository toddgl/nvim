-- File: lua/plugins/enhancements/nvim-lsp-ui.lua
-- Optional polish for LSP experience

return {
  {
    "onsails/lspkind.nvim",
    lazy = true,
    config = function()
      local lspkind = require("lspkind")
      lspkind.init({
        mode = "symbol_text", -- show symbol + text
        preset = "default",
        symbol_map = {
          Text = "",
          Method = "",
          Function = "󰊕",
          Constructor = "",
          Field = "󰇽",
          Variable = "󰂡",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "󰅲",
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy", -- use legacy until 1.0 is stable
    event = "LspAttach",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
        },
        window = {
          blend = 0,
        },
      })
    end,
  },
}

