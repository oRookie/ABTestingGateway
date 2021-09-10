local utils = require('abtesting.utils.utils')

local _M = {
    _VERSION = '0.01'
}

_M.get = function()
    local rate = 0
    local ClientIP = ngx.req.get_headers()["X-Real-IP"]
    if ClientIP == nil then
        ClientIP = ngx.req.get_headers()["X-Forwarded-For"]
        if ClientIP then
            local colonPos = string.find(ClientIP, ' ')
            if colonPos then
                ClientIP = string.sub(ClientIP, 1, colonPos - 1)
            end
        end
    end
    if ClientIP == nil then
        ClientIP = ngx.var.remote_addr
    end
    if ClientIP then
        rate = utils.hash(ClientIP) % 100
    end
    return rate
end

return _M



