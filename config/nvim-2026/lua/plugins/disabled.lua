local disabled = {
  { "akinsho/bufferline.nvim" },
}

for k, plugin in ipairs(disabled) do
  plugin.enabled = false
end

return disabled
