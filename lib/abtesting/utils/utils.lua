local modulename = "abtestingUtils"
local _M = {}
_M._VERSION = '0.0.1'
local cjson = require('cjson.safe')
local log = require("abtesting.utils.log")
local bit = require "bit"
local ffi = require("ffi")
ffi.cdef[[
    struct timeval {
        long int tv_sec;
        long int tv_usec;
    };
    int gettimeofday(struct timeval *tv, void *tz);
]];
local lshift = bit.lshift
local rshift = bit.rshift
local bxor = bit.bxor

local byte = string.byte
local sub = string.sub
local len = string.len
--将doresp和dolog，与handler统一起来。
--handler将返回一个table，结构为：
--[[
handler———errinfo————errcode————code
    |           |               |
    |           |               |————info
    |           |
    |           |————errdesc
    |
    |
    |
    |———errstack				 
]]--		

_M.dolog = function(info, desc, data, errstack)
    --    local errlog = 'ab_admin '
    local errlog = ''
    local code, err = info[1], info[2]
    local errcode = code
    local errinfo = desc and err .. desc or err

    errlog = errlog .. 'code : ' .. errcode
    errlog = errlog .. ', desc : ' .. errinfo
    if data then
        errlog = errlog .. ', extrainfo : ' .. data
    end
    if errstack then
        errlog = errlog .. ', errstack : ' .. errstack
    end
    return errlog
end

_M.doresp = function(info, desc, data)
    local response = {}

    local code = info[1]
    local err = info[2]
    response.code = code
    response.desc = desc and err .. desc or err
    if data then
        response.data = data
    end

    return cjson.encode(response)
end

_M.doerror = function(info, extrainfo)
    local errinfo = info[1]
    local errstack = info[2]
    local err, desc = errinfo[1], errinfo[2]

    local dolog, doresp = _M.dolog, _M.doresp
    local errlog = dolog(err, desc, extrainfo, errstack)
    log:errlog(errlog)

    local response = doresp(err, desc)
    return response
end

_M.hash = function(str)
    local l = len(str)
    local h = l
    local step = rshift(l, 5) + 1

    for i = l, step, -step do
        h = bxor(h, (lshift(h, 5) + byte(sub(str, i, i)) + rshift(h, 2)))
    end
    return h
end

_M.delArrayElement = function(src, del)
    local temp = {}
    local hash_del = {}
    for key, var in pairs(del) do
        hash_del[var] = (hash_del[var] or 0) + 1
    end
    for key, var in pairs(src) do
        if (hash_del[var] and (hash_del[var] > 0)) then
            src[key] = nil
        end
    end
    for key, var in pairs(src) do
        table.insert(temp, var)
    end
    return temp
end

_M.split = function(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

_M.randomseed = function()
    local tm = ffi.new("struct timeval");
    ffi.C.gettimeofday(tm, nil);
    local sec = tonumber(tm.tv_sec);
    local usec = tonumber(tm.tv_usec);
    return sec + usec * 10 ^ 9;
end

return _M
