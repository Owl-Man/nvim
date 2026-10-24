vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- vim.keymap.set("n", "-", vim.cmd.Ex)

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("n", "<leader>lt", function()
    vim.cmd [[ PlenaryBustedFile % ]]
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", function()
  require("telescope.builtin").find_files({ default_text = vim.fn.expand("<cword>") })
end)
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set(
    "n",
    "<leader>ea",
    "oassert.NoError(err, \"\")<Esc>F\";a"
)

vim.keymap.set(
    "n",
    "<leader>ef",
    "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
)

vim.keymap.set(
    "n",
    "<leader>el",
    "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
)


vim.keymap.set("n", "<leader>pf", function()
  require("telescope.builtin").find_files()
end)

vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").git_files()
end)

vim.keymap.set("n", "<leader>ps", function()
  require("telescope.builtin").grep_string({
    search = vim.fn.input("Grep > "),
  })
end)

vim.keymap.set("n", "<leader>psw", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end)


vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>Git log --graph --oneline --decorate --all<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>Git branch -a<CR>", { desc = "Git branch list (all)" })
vim.keymap.set("n", "<leader>gm", function()
  vim.ui.input({ prompt = "Merge branch: " }, function(branch)
    if branch and branch ~= "" then
      vim.cmd("Git merge " .. branch)
    end
  end)
end, { desc = "Git merge" })
vim.keymap.set("n", "<leader>gP", function()
  vim.ui.input({ prompt = "Cherry-pick SHA: " }, function(sha)
    if sha and sha ~= "" then
      vim.cmd("Git cherry-pick " .. sha)
    end
  end)
end, { desc = "Git cherry-pick" })
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "p", "<cmd>Git pull<CR>", { buffer = true, desc = "Git pull" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitive", "git" },
  callback = function()
    vim.keymap.set("n", "cp", "<cmd>Git cherry-pick <C-R>=expand('<cfile>')<CR><CR>", {
      buffer = true,
      desc = "Cherry-pick commit under cursor",
    })
    vim.keymap.set("n", "cP", "<cmd>Git cherry-pick --no-commit <C-R>=expand('<cfile>')<CR><CR>", {
      buffer = true,
      desc = "Cherry-pick commit under cursor (no commit)",
    })
  end,
})


vim.keymap.set("n", "<space>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)
end)

vim.keymap.set("t", "<C-t>", "<C-\\><C-N>")
