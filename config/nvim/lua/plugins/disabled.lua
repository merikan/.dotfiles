local disabled = {
  { "akinsho/bufferline.nvim" },
  { "MeanderingProgrammer/render-markdown.nvim" },
}

for k, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
