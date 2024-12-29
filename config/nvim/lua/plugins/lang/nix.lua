-- nix language
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.nix = opts.linters_by_ft.nix or {}
      table.insert(opts.linters_by_ft.nix, "statix")
      return opts
    end,
  },
  {
    "warpaint9299/nvim-devdocs",
    ensure_installed = {
      "nix",
    },
  },
}
