local status, _ = pcall(vim.cmd, "colorscheme nord")
if not status then
  print("Colorscheme not found!")
  return
end

vim.cmd[[ hi Normal guibg=NONE ctermbg=NONE ]]
