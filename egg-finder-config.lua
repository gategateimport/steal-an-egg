local function loadConfig()
    local env = type(getgenv) == 'function' and getgenv() or _G
    local data, err
    if type(env.XLZ_CONFIG) == 'table' then
        data = env.XLZ_CONFIG
    else
        local url = type(env.XLZ_CONFIG_URL) == 'string' and env.XLZ_CONFIG_URL
            or 'https://raw.githubusercontent.com/syss1211/Tenshi-script/main/NYX-Contabo-Config.json'
        data, err = network(url .. '?nyx=' .. os.time(), 'GET', nil, nil, false, 4)
    end
    if not data then return false, err end
    if type(data.endpoint) ~= 'string' or not data.endpoint:match('^https://[%w%.%-]+$') or type(data.roomKey) ~= 'string' then
        return false, 'Contabo configuration unavailable'
    end
    local trial = data.endpoint .. '/finder'
    local roomKey = data.roomKey
    featureConfig = {endpoint = trial .. '/feature', roomKey = roomKey}
    publicBroadcastConfig = {endpoint = trial .. '/primary', roomKey = roomKey}
    configAt = os.clock()
    return true
end
