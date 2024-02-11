return {
  { import = "lazyvim.plugins.extras.lang.rust" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-plenary"] = {},
        ["neotest-rust"] = {},
      },
    },
  },
 }
