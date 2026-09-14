local M = {}

M.last_output = {}

local function fill_qf(lines)
  vim.fn.setqflist({}, "r", {
    title = "gcc " .. os.date("%H:%M:%S"),
    efm = "%f(%l,%c): %m,%f:%l:%c: %m,%f:%l: %m",
    lines = lines,
  })
end

local function run_build(args, on_success)
  if vim.bo.modified then
    vim.cmd("write")
  end
  local out = {}
  local function collect(_, data)
    for _, l in ipairs(data) do
      if l ~= "" then
        out[#out + 1] = l
      end
    end
  end
  local job = vim.fn.jobstart(args, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = collect,
    on_stderr = collect,
    on_exit = function(_, code)
      vim.schedule(function()
        M.last_output = out
        fill_qf(out)
        if code == 0 then
          vim.notify("gcc: OK", vim.log.levels.INFO)
          if on_success then
            on_success(out)
          end
        else
          vim.notify(("gcc: FAILED (exit %d)"):format(code), vim.log.levels.ERROR)
          vim.cmd("copen")
        end
      end)
    end,
  })
  if job == 0 then
    vim.notify("gcc: failed to start", vim.log.levels.ERROR)
  end
end

function M.compile_check()
  local src = vim.fn.expand("%:p")
  local obj = "/tmp/" .. vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r") .. ".o"
  run_build({ "gcc", "-Wall", "-Wextra", "-g", "-c", src, "-o", obj })
end

function M.compile_and_run()
  local src = vim.fn.expand("%:p")
  local bin = "/tmp/" .. vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
  run_build({ "gcc", "-Wall", "-Wextra", "-g", src, "-o", bin }, function()
    vim.cmd("belowright split")
    vim.fn.termopen({ "sh", "-c", ("echo '--- program output ---'; exec %s"):format(vim.fn.shellescape(bin)) })
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function(args)
    vim.keymap.set("n", "<leader>cr", M.compile_and_run, { buffer = args.buf, desc = "Compile & run (gcc)" })
    vim.keymap.set("n", "<leader>cc", M.compile_check, { buffer = args.buf, desc = "Compile check (gcc -c)" })
  end,
})

return M