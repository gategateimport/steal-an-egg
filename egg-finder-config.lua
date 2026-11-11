local env = type(getgenv) == 'function' and getgenv() or _G
local Http = game:GetService('HttpService')
local requestFn = request or http_request or (syn and syn.request) or (http and http.request)

env.loadConfig = function()
    local data
    if type(env.XLZ_CONFIG) == 'table' then
        data = env.XLZ_CONFIG
    else
        if type(requestFn) ~= 'function' then return nil, 'Executor HTTP unavailable' end
        local url = type(env.XLZ_CONFIG_URL) == 'string' and env.XLZ_CONFIG_URL
            or 'https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX-Contabo-Config.json'
        local ok, response = pcall(requestFn, {Url = url .. '?nyx=' .. os.time(), Method = 'GET', Timeout = 4})
        if not ok or type(response) ~= 'table' or tonumber(response.StatusCode or response.Status) ~= 200 then
            return nil, 'Config request failed'
        end
        local good, decoded = pcall(Http.JSONDecode, Http, response.Body or '')
        if not good then return nil, 'Config JSON invalid' end
        data = decoded
    end
    if type(data) ~= 'table' or type(data.endpoint) ~= 'string' or not data.endpoint:match('^https://[%w%.%-]+$') or type(data.roomKey) ~= 'string' then
        return nil, 'Config invalid'
    end
    return {endpoint = data.endpoint, roomKey = data.roomKey}
end
