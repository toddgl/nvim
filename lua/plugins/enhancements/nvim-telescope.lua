-- A highly extendable fuzzy finder over lists

local builtin = require("telescope.builtin")

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")

        -- helper to grab visual selection
        local function get_visual_selection()
            local _, ls, cs = unpack(vim.fn.getpos("'<"))
            local _, le, ce = unpack(vim.fn.getpos("'>"))
            local lines = vim.fn.getline(ls, le)
            if #lines == 0 then return "" end
            lines[#lines] = string.sub(lines[#lines], 1, ce)
            lines[1] = string.sub(lines[1], cs)
            return table.concat(lines, "\n")
        end

        -- keymaps
        vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>ts", builtin.live_grep,  { desc = "Live grep" })
        vim.keymap.set("n", "<leader>tb", builtin.buffers,    { desc = "List buffers" })
        vim.keymap.set("n", "<leader>tr", builtin.resume,     { desc = "Resume picker" })

        vim.keymap.set("n", "<leader>tg", function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end, { desc = "Grep word under cursor" })

        vim.keymap.set("v", "<leader>tv", function()
            builtin.grep_string({ search = get_visual_selection() })
        end, { desc = "Grep visual selection" })
    end,
    extensions = {
        "fzf",
    },
}

