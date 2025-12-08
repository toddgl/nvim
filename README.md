# Neovim from Scratch

This neovim configuration is being build up incrementally from scratch. But was based on this FreeBSD article - [Neovim as an IDE for programming](https://forums.freebsd.org/threads/neovim-as-an-ide-for-programming.97059/)

All muy plugins are installed in the lua/plugins/enhancements folder

 - [X] autopairs
   This plugin enables to create a pair of:
    -> parentheses ()
    -> square brackets []
    -> triangle brackets <>
    -> braces {}
    -> single quotation marks ''
    -> double quotation marks ""
    -> backquotes ``
    it puts your mouse inside the pair each time you want to create one.
 - [X] cmp
    - auto completion suggestions for many languages
 - [X] color theme
    - preferred color theme - tokyonight-night
 - [X] debugger
    - a Debug Adapter Protocol client
        - Launch an application to debug
        - Attach to running applications and debug them
        - Set breakpoints and step through code
        - Inspect the state of the application
    - Uses <leader> d
 - [X] float term
    - Use (neo)vim terminal in the floating/popup window.
    - :FloatermNew <cmd> e.g. :FloatermNew python
    - or <F7> to open terminal window
 - [x] laxygit
    - <leader>lg or :LazyGit
 - [X] lsp ui
    - adds a clear, consistent iconography layer to Neovim’s completion UI (LSP, snippets, paths, etc.). 
 - [X] lualine lsp progressadds a clear, consistent iconography layer to Neovim’s completion UI (LSP, snippets, paths, etc.). 
    - displays  on the progress line the active lsp
 - [X] lualine
    - A lightweight statusline
 - [X] mini icons
    - provides icon integration, customizable styles, and highlighting for various categories such as filetypes, paths, extensions, LSP kinds, with caching for performance, and integration with 'nvim-tree/nvim-web-devicons' methods.
 - [X] neo tree
    plugin to browse the file system and other tree like structures
 - [X] nvzone menu
    - Menu ui for neovim ( supports nested menus )
 - [X] render markdown
    - Plugin to improve viewing Markdown files in Neovim 
 - [X] telescope
    - a fuzzy finder with preview pick 
    - <leader>t_
 - [X] tree sitter
    - provides syntax highlighting based on parser language
 - [X] which key
    - a popular Neovim plugin designed to enhance user experience by providing real-time, contextual help for keybindings. 
 - [X] window picker
 - [X] gemini-cli
    - a plug in to use the gemini AI functionality
    - Use the keymap <leader>og to open and close the Gemini CLI window.
    - In visual mode, select one or more lines and use the keymap <leader>sg to send the selected text to the Gemini CLI. If the CLI window is not open, a floating message will prompt you to open it first.
- [X] nvim-gemini-companion
    - Brings the power of AI agents like Gemini and Qwen directly into the Neovim workflow. 🌟 Enjoy seamless diff views, agent management, and smart file modifications without leaving the editor.
    - Core Commands
        - :GeminiToggle - Toggle the AI sidebar
        - :GeminiSwitchToCli - Spawn or Switch to tmux/sidebar sessions
        - :GeminiSend - Send selected text to AI (use in visual mode)
        - :GeminiSendLineDiagnostic - Send line diagnostics to AI
        - :GeminiSendFileDiagnostic - Send file diagnostics to AI
        - :GeminiSwitchSidebarStyle - Switch the appearance/style of the sidebar
