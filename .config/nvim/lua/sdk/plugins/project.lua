local setup, project_nvim = pcall(require, "project_nvim")
if not setup then
    print("No project_nvim installed")
    return
end
project_nvim.setup({})
