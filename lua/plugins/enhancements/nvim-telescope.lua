-- A highly extendable fuzzy finder over lists

-- telescope plugin spec

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make", optional = true },
        { "nvim-telescope/telescope-fzf-writer.nvim", optional = true },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        -- helper to grab visual selection text
        local function get_visual_selection()
            local _, ls, cs = unpack(vim.fn.getpos("'<"))
            local _, le, ce = unpack(vim.fn.getpos("'>"))
            local lines = vim.fn.getline(ls, le)
            if #lines == 0 then return "" end
            lines[#lines] = string.sub(lines[#lines], 1, ce)
            lines[1] = string.sub(lines[1], cs)
            return table.concat(lines, "\n")
        end

        -- Normal mode mappings
        vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>ts", builtin.live_grep,  { desc = "Live grep" })
        vim.keymap.set("n", "<leader>tb", builtin.buffers,    { desc = "List buffers" })
        vim.keymap.set("n", "<leader>tr", builtin.resume,     { desc = "Resume picker" })
        vim.keymap.set("n", "<leader>tg", function()
            builtin.grep_string({ search = vim.fn.expand("<cword>") })
        end, { desc = "Grep word under cursor" })

        -- Visual mode mapping
        vim.keymap.set("v", "<leader>tv", function()
            builtin.grep_string({ search = get_visual_selection() })
        end, { desc = "Grep visual selection" })

        -- Try native fzf first, fallback to fzf_writer
        local ok, _ = pcall(telescope.load_extension, "fzf")
        if not ok then
            pcall(telescope.load_extension, "fzf_writer")
        end
    end,
}

