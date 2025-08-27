-- My preferred color theme for neovim and transparency feature for the background

return {
    "Mofiqul/dracula.nvim",
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd("colorscheme dracula")
    end,
}
