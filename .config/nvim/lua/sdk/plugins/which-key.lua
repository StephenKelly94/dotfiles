local setup, wk = pcall(require, "which-key")
if not setup then
    print("No which-key installed")
    return
end

wk.register({
    b = {
        name = "Buffers",
        j = { "<cmd>BufferLinePick<cr>", "Jump" },
        f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
        b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
        n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
        e = {
            "<cmd>BufferLinePickClose<cr>",
            "Pick which buffer to close",
        },
        h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
        l = {
            "<cmd>BufferLineCloseRight<cr>",
            "Close all to the right",
        },
        D = {
            "<cmd>BufferLineSortByDirectory<cr>",
            "Sort by directory",
        },
        L = {
            "<cmd>BufferLineSortByExtension<cr>",
            "Sort by language",
        },
    },
    c = {
        function()
            require("sdk.core.functions").buf_kill("bd")
        end,
        "Close buffer"
    },
    e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
    f = {
        function()
            require("sdk.plugins.telescope.custom-finders").find_project_files()
        end,
        "Find file"
    },
    g = {
        name = "Git",
        g = { "<cmd>lua require('lvim.core.terminal').lazygit_toggle()<cr>", "Lazygit" },
        j = { "<cmd>lua require('gitsigns').next_hunk({navigation_message = false})<cr>", "Next Hunk" },
        k = { "<cmd>lua require('gitsigns').prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
        l = { "<cmd>lua require('gitsigns').blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require('gitsigns').reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require('gitsigns').stage_hunk()<cr>", "Stage Hunk" },
        u = { "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", "Undo Stage Hunk" },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
        d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff" },
        D = { "<cmd>Git diff<CR>", "Diff all" },
        f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
    },
    h = {
        name = "Harpoon",
        a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add mark"},
        t = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle list"},
        q = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Mark 1"},
        w = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Mark 2"},
        e = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Mark 3"},
        r = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Mark 4"},
    },
    H = {"<cmd>nohl<CR>", "Remove highlight"},
    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
        w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
        -- f = { require("lvim.lsp.utils").format, "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>Mason<cr>", "Mason Info" },
        j = {
            vim.diagnostic.goto_next,
            "Next Diagnostic",
        },
        k = {
            vim.diagnostic.goto_prev,
            "Prev Diagnostic",
        },
        l = { vim.lsp.codelens.run, "CodeLens Action" },
        q = { vim.diagnostic.setloclist, "Quickfix" },
        r = { vim.lsp.buf.rename, "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
        },
        e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    },
    o = {
        name = "Split",
        e = {"<C-w>=", "Equalize splits"},
        h = {"<C-w>s", "Horizontal split"},
        v = {"<C-w>v", "Vertical split"},
        H = {"<C-w>H", "Move split left"},
        J = {"<C-w>J", "Move split bottom"},
        K = {"<C-w>K", "Move split top"},
        L = {"<C-w>L", "Move split right"},
    },
    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },
    q = {"<cmd>lua require('sdk.core.functions').smart_quit()<CR>", "Quit"},
    s = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope live_grep<cr>", "Text" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
        p = {
            "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
            "Colorscheme with Preview",
        },
    },
    T = {
        name = "Treesitter",
        i = { ":TSConfigInfo<cr>", "Info" },
    },
    u = {"<cmd>UndotreeToggle<CR>", "UndoTree"},
    w = {"<cmd>w!<CR>", "Save"},
    z = {"<cmd>lua require('maximize').toggle()<CR>", "Maximize Toggle"},
}, { prefix = "<leader>" })
