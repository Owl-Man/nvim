local function compile_and_run()
  if vim.bo.modified then
    vim.cmd("write")
  end
  local out = vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
  local bin = "/tmp/" .. out
  local cmd = ("gcc -Wall -Wextra -g %s -o %s && %s"):format(vim.fn.expand("%:p"), bin, bin)
  vim.cmd("belowright split")
  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end

local function compile_check()
  if vim.bo.modified then
    vim.cmd("write")
  end
  local cmd = "gcc -Wall -Wextra -g -c " .. vim.fn.expand("%:p")
  vim.cmd("belowright split")
  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function(args)
    vim.keymap.set("n", "<leader>cr", compile_and_run, { buffer = args.buf, desc = "Compile & run (gcc)" })
    vim.keymap.set("n", "<leader>cc", compile_check, { buffer = args.buf, desc = "Compile check (gcc -c)" })
  end,
})

return {}