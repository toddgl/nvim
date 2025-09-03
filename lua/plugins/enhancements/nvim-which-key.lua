-- This plugin displays a popup window with all possible keybindings that follow the key sequence you've started typing

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require('which-key').setup({})
  end,
}

