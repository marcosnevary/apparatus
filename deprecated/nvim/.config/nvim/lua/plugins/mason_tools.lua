return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "vtsls",
        "html-lsp",
        "css-lsp",
        "eslint_d",
        "prettierd",
      },
    },
  },
}
