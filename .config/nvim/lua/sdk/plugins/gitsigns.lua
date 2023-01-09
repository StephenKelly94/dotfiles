local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
    print("No gitsigns installed")
    return
end
gitsigns.setup({
    signs = {
        add = { hl = 'GitSignsAdd', text = '+', numhl='GitSignsAddNr', linehl='GitSignsAddLn' }
    }
})
