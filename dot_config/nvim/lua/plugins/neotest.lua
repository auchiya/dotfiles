return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        -- Use pnpm, yarn, or npx depending on your package manager:
        vitestCommand = "pnpm exec vitest run",
        -- Or if using npm: "npx vitest"
      },
    },
  },
}
