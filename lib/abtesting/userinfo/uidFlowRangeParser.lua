local utils = require('abtesting.utils.utils')

local _M = {
    _VERSION = '0.01'
}

_M.get = function()
    local rate = 0
    local uid = ngx.req.get_headers()["X-Uid"]
    if uid then
        rate = utils.hash(uid) % 100
    end
    return rate
end

return _M



