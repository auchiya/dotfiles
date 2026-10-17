return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
              },
              preferences = {
                -- Forces TS Server to search node_modules for unimported package exports
                includePackageJsonAutoImports = "auto",
                importModuleSpecifierPreference = "non-relative",
              },
            },
            javascript = {
              suggest = {
                autoImports = true,
              },
              preferences = {
                includePackageJsonAutoImports = "auto",
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              -- Ensures gopls sees all files across subdirectories/packages
              directoryFilters = { "-**/node_modules", "-**/.git" },
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
              -- Helps gopls load multi-module workspaces or sibling package files
              buildFlags = { "-tags=integration" }, -- Add tags if you use build tags
            },
          },
        },
      },
    },
  },
}
