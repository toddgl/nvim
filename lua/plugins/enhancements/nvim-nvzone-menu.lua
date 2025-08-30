return {
  -- Add the menu plugin
  "nvzone/volt",
  "nvzone/menu",



  -- Configure the plugin
  opts = {
    -- The keymap used to open the menu.
    -- Default value is "<leader>m".
    -- This example uses `"<leader>"` and `v` to create a menu.
    keymap = "<leader>v",

    -- You can customize the menu items here.
    -- This is a nested structure where you define the menu.
    items = {
      -- A simple command to quit Neovim.
      {
        id = "Quit",
        action = ":qa<CR>",
      },
      -- A nested menu for file-related actions.
      {
        id = "File",
        items = {
          -- Save the current file.
          {
            id = "Save",
            action = ":w<CR>",
          },
          -- Open a new file.
          {
            id = "New File",
            action = ":e<CR>",
          },
        },
      },
    },
  },
}
