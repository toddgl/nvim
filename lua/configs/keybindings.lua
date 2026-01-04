
-- Keybindings for neovim editor

-- Redefine map leader from "\" to " "
vim.g.mapleader = " "

-- Make mapping to keys easier
local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- none-ls
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer" })

-- Refactoring
-- Set <leader>rn to call the built-in LSP rename function
vim.keymap.set("n", "<leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "LSP rename" })

