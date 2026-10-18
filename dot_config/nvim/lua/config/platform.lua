-- Load OS-specific config if present.
-- Override by adding (chezmoi only materializes the file on its OS):
--   lua/config/platform/macos.lua
--   lua/config/platform/windows.lua
--   lua/config/platform/linux.lua
--   lua/config/platform/wsl.lua   (WSL, loaded after linux)

local function is_wsl()
  local f = io.open("/proc/sys/kernel/osrelease", "r")
  if not f then
    return false
  end
  local content = f:read("*a")
  f:close()
  return content ~= nil and content:lower():find("microsoft", 1, true) ~= nil
end

local function os_name()
  if vim.fn.has("win32") == 1 then
    return "windows"
  end
  if vim.fn.has("mac") == 1 then
    return "macos"
  end
  return "linux"
end

local names = { os_name() }
if is_wsl() then
  table.insert(names, "wsl")
end

for _, name in ipairs(names) do
  pcall(require, "config.platform." .. name)
end
