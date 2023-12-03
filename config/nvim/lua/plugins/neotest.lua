-- For test runners:
-- https://github.com/nvim-neotest/neotest#supported-runners
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-plenary",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
      "sidlatau/neotest-dart"
    },
    opts = {
      adapters = {
        ["neotest-plenary"] = {},
        ["neotest-java"] = {},
        ["neotest-go"] = {},
        ["neotest-rust"] = {},
        ["neotest-dart"] = {},
      },
    },
  },
}
