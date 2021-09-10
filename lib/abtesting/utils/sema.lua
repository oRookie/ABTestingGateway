local modulename = "abtestingSema"
local _M = {}

local semaphore = require("ngx.semaphore")

_M.sema = semaphore.new(1)
_M.upsSema = semaphore.new(1)
_M.modulename = modulename

return _M
