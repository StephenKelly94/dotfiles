local autopairs_status, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_status then
    print("No autopairs installed")
    return
end

local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_status then
    print("No cmp_autopairs installed")
    return
end

local cmp_setup, cmp = pcall(require, "cmp")
if not cmp_setup then
    print("No cmp installed")
    return
end

autopairs.setup({
    check_ts = true,
    ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
    },
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
