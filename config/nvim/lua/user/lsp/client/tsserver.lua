
local M = {}

M.update = function( client )
  client.resolved_capabilities.document_formatting = false
end

return M
