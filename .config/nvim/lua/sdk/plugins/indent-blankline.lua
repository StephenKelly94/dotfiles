local setup, indent_blankline = pcall(require, "indent_blankline")
if not setup then
    print("No indent_blankline installed")
    return
end

indent_blankline.setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
})
