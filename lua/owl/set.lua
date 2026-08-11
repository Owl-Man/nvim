vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = ""

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.clipboard = "unnamedplus"

vim.opt.syntax = "off"

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    vim.cmd("silent! checktime")
  end,
})

local git_status = vim.api.nvim_create_augroup("GitStatusColors", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  group = git_status,
  callback = function()
    local colors = {
      D = { fg = "#ff6b6b" },
      M = { fg = "#ffd866" },
      A = { fg = "#a9dc76" },
      R = { fg = "#78dce8" },
      U = { fg = "#ff9f1c" },
    }
    for letter, c in pairs(colors) do
      local hl = "FugitiveStatus" .. letter
      vim.api.nvim_set_hl(0, hl, { fg = c.fg, bold = true })
      vim.fn.matchadd(hl, "\\v^" .. letter .. "%( |. )")
      vim.fn.matchadd(hl, "\\v^%(.)" .. letter .. " ")
    end
  end,
})
