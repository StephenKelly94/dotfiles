local setup, telescope = pcall(require, "telescope")
if not setup then
    print("No telescope installed")
    return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
    print("No telescope actions installed")
    return
end


telescope.setup({
    active = true,
    on_config_done = nil,
    theme = "dropdown",
    defaults = {
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = nil,
        layout_strategy = nil,
        layout_config = nil,
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
        },
        ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
        mappings = {
            i = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<CR>"] = actions.select_default,
            },
            n = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
        file_ignore_patterns = {},
        path_display = { "smart" },
        winblend = 0,
        border = {},
        borderchars = nil,
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            --@usage don't include the filename in the search results
            only_sort_text = true,
        },
        grep_string = {
            only_sort_text = true,
        },
        buffers = {
            initial_mode = "normal",
            mappings = {
                i = {
                    ["<C-d>"] = actions.delete_buffer,
                },
                n = {
                    ["dd"] = actions.delete_buffer,
                },
            },
        },
        planets = {
            show_pluto = true,
            show_moon = true,
        },
        git_files = {
            hidden = true,
            show_untracked = true,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        }
    },
})
telescope.load_extension("fzf")
telescope.load_extension("projects")
