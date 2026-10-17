-- Chrome/js-debug DAP configs for a TS/React SPA.
-- LazyVim's lang.typescript extra already installs js-debug-adapter and
-- registers the pwa-chrome adapter; this only adds browser launch/attach configs.

local function browser_configs()
  -- nvim-dap calls __call at launch time (:h dap-configuration), so we can
  -- prompt for the URL while keeping localhost:5173 as the default.
  local launch = {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome (default :5173)",
    url = "http://localhost:5173",
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
  }
  setmetatable(launch, {
    __call = function(self)
      local url = vim.fn.input("Debug URL: ", self.url)
      local c = {}
      for k, v in pairs(self) do
        c[k] = v
      end
      c.url = (url ~= "" and url) or self.url
      return c
    end,
  })

  local attach = {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome (:9222)",
    port = 9222,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
  }

  return { launch, attach }
end

-- Attach to the Go backend running under Delve inside Docker.
-- Container is started with:
--   docker compose -f docker-compose.yml -f docker-compose.debug.yml up --build api-debug
-- and publishes the Delve DAP server on 127.0.0.1:2345.
-- A dedicated adapter is used (instead of nvim-dap-go's "go") because that
-- adapter always spawns a local dlv, which would collide with the forwarded port.
local function go_docker()
  local dap = require("dap")

  dap.adapters.delve_remote = {
    type = "server",
    host = "127.0.0.1",
    port = 2345,
  }

  -- Computed at launch time so it works whether nvim is opened at the repo
  -- root or directly in backend/.
  local config = setmetatable({
    type = "delve_remote",
    name = "Attach to Docker (delve :2345)",
    request = "attach",
    mode = "remote",
  }, {
    __call = function(self)
      local cwd = vim.fn.getcwd()
      local backend = cwd:match("/backend$") and cwd or (cwd .. "/backend")
      local c = vim.tbl_extend("force", {}, self)
      c.substitutePath = { { from = backend, to = "/app" } }
      return c
    end,
  })

  dap.configurations.go = dap.configurations.go or {}
  table.insert(dap.configurations.go, config)
end

return {
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")
      for _, lang in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[lang] = vim.list_extend(browser_configs(), dap.configurations[lang] or {})
      end
      go_docker()
      return opts
    end,
  },
}
