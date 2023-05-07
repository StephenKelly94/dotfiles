local setup, alpha = pcall(require, "alpha")
if not setup then
    print("No alpha installed")
    return
end

local _, alpha_theme = pcall(require, "alpha.themes.dashboard")
if not setup then
    print("No alpha_theme installed")
    return
end

alpha_theme.section.header.val = {
"  ********   *******     **   **",
" **//////   /**////**   /**  ** ",
"/**         /**    /**  /** **  ",
"/*********  /**    /**  /****   ",
"////////**  /**    /**  /**/**  ",
"       /**  /**    **   /**//** ",
" ********   /*******    /** //**",
"////////    ///////     //   // ",
}

alpha_theme.section.buttons.val = {
  alpha_theme.button("e", "󰈙  New File    ", ":enew<CR>"),
  alpha_theme.button("f", "  Find File   ", ":Telescope find_files<CR>"),
  alpha_theme.button("t", "󰊄  Find Text   ", ":Telescope live_grep<CR>"),
  alpha_theme.button("p", "  Projects    ", ":Telescope projects<CR>"),
  alpha_theme.button("c", "  NVIM Config ", ":cd ~/.config/nvim | :e ~/.config/nvim/lua/sdk/plugins-setup.lua <CR>"),
  alpha_theme.button("q", "  Quit        ", ":qa<CR>"),
}

alpha_theme.section.footer.val = require('alpha.fortune')()

alpha.setup(alpha_theme.config)
