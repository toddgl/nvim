-- Best effort collection of LSP server configurations

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/lazydev.nvim", opts = {} },
    },
    config = function()
        -- local nvim_lsp = require("lspconfig")
        -- local protocol = require("vim.lsp.protocol")
        local on_attach = function(client, bufnr)
            -- Format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end
    end,
}
