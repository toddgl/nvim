-- mini.icons plugin

return {
  "nvim-mini/mini.icons",
  config = function()
    require("mini.icons").setup({
      -- Example: Mock nvim-web-devicons for compatibility
      mock_nvim_web_devicons = true,
    })
  end,
}
