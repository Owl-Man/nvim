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


-- Fugitive не умеет разбирать oil:// и для oil-буфера берёт репозиторий от cwd.
-- На время :Git подставляем git_dir из директории oil, затем возвращаем как было.
vim.keymap.set("n", "<leader>gs", function()
  if vim.bo.filetype ~= "oil" then
    vim.cmd("Git")
    return
  end

  local ok_oil, oil = pcall(require, "oil")
  local dir = ok_oil and oil.get_current_dir() or nil
  local git_dir
  if dir and dir ~= "" then
    local res = vim.system({ "git", "-C", dir, "rev-parse", "--absolute-git-dir" }, { text = true }):wait()
    if res.code == 0 and res.stdout then
      git_dir = vim.trim(res.stdout)
    end
  end

  if not git_dir or git_dir == "" then
    vim.cmd("Git")
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local previous = vim.b[buf].git_dir
  vim.b[buf].git_dir = git_dir
  local ok, err = pcall(vim.cmd, "Git")
  vim.b[buf].git_dir = previous
  if not ok then
    error(err)
  end
end)
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


local function current_dir()
  local dir
  if vim.bo.filetype == "oil" then
    local ok, oil_dir = pcall(function()
      return require("oil").get_current_dir()
    end)
    if ok then
      dir = oil_dir
    end
  end

  if not dir or dir == "" or vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.expand("%:p:h")
  end
  if dir == "" or vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.getcwd()
  end
  return dir
end

vim.keymap.set("n", "<space>st", function()
    local dir = current_dir()
    vim.cmd.vnew()
    vim.cmd.wincmd("J")
    vim.fn.termopen({ vim.o.shell }, { cwd = dir })
    vim.api.nvim_win_set_height(0, 15)
end)

local function open_yazi()
  local dir = current_dir()

  if vim.fn.executable("yazi") ~= 1 then
    vim.notify("yazi не найден в PATH", vim.log.levels.ERROR)
    return
  end

  if vim.env.TMUX and vim.env.TMUX ~= "" and vim.fn.executable("tmux") == 1 then
    vim.system({
      "tmux", "new-pane",
      "-x", "90%",
      "-y", "90%",
      "-X", "0",
      "-Y", "0",
      "-c", dir,
      "yazi",
      ";", "move-pane", "-P", "centre",
    }, { text = true }, function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          vim.notify("tmux: не удалось открыть панель с yazi" .. (res.stderr and (": " .. res.stderr) or ""), vim.log.levels.ERROR)
        end)
      end
    end)
    return
  end

  vim.cmd.vnew()
  vim.cmd.wincmd("J")
  vim.fn.termopen({ "yazi", dir }, { cwd = dir })
  vim.cmd("wincmd =")
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>sf", open_yazi, { desc = "Yazi в директории текущего файла" })

vim.keymap.set("t", "<C-t>", "<C-\\><C-N>")
