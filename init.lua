require("owl")

local socket_path = "/tmp/nvimsocket"
if vim.fn.filereadable(socket_path) == 1 then
  os.remove(socket_path)
end
pcall(vim.fn.serverstart, socket_path)
