return
  {
  -- plugin for previewing native LSP's goto definition, type definition, implementation, declaration and references calls in floating windows.
  -- https://github.com/rmagatti/goto-preview
  'rmagatti/goto-preview',
  config = function()
    require('goto-preview').setup {}
  end
}
