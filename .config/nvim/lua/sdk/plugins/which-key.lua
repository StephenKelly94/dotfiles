local setup, wk = pcall(require, "which-key")
if not setup then
    print("No which-key installed")
    return
end

wk.register({
    b = {
        name = "Buffers",
        f = {"<cmd>Telescope buffers previewer=false<cr>", "Find"},
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
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = {
          "<cmd>Telescope git_bcommits<cr>",
          "Checkout commit(for current file)",
        },
    },
    H = {"<cmd>nohl<CR>", "Remove highlight"},
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
    u = {"<cmd>UndotreeToggle<CR>", "UndoTree"},
    w = {"<cmd>w!<CR>", "Save"},
    z = {"<cmd>lua require('maximize').toggle()<CR>", "Maximize Toggle"},
}, { prefix = "<leader>" })
