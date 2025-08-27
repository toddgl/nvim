-- Neovims plugin manager

-- Bootstrap lazy vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy vims behaviour
require("lazy").setup({
    spec = {
        -- Tell lazy vim where it should look for plugins
        { import = "plugins.enhancements" },
        { import = "plugins.lsp-config" }
    },
    checker = {
        enabled = true, -- Check for plugin updates upon start
        notify = false, -- Notify on update
    },
    change_detection = {
        notify = false, -- Notify on detection change
    },
})

-- Enable transparent background in lazys UI
function Transparent(color)
    color = color
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
Transparent()
