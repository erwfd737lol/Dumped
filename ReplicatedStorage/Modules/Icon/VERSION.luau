
local v1 = nil

local function getLatestVersion() --[[ Upvalues: v1 (copy) ]]
    local latestVersion = v1.latestVersion
    if latestVersion then
        return latestVersion
    end

    local v2
    while true do
        local v4, v5 = pcall(function()
            local MarketplaceService = game:GetService("MarketplaceService")
            local v3 = MarketplaceService:GetProductInfo(117501901079852)
            return v3
        end)
        if v4 and v5 then
            v2 = v5.Name
            break
        end

        task.wait(1)
    end

    local v7 = string.match(v2, "^TopbarPlus (.*)$") and string.match(v2, "^TopbarPlus (.*)$"):gsub("%s+", "")
    v1.latestVersion = v7
    return v7
end

local function getAppVersion() --[[ Upvalues: v1 (copy) ]]
    return v1.appVersion
end

local function isUpToDate() --[[ Upvalues: v1 (copy) ]]
    local v8 = v1.getLatestVersion()
    local v9 = v1.getAppVersion()
    local v10 = false
    if v8 ~= nil then
        v10 = v8 == v9
    end

    return v10
end

v1 = {
    appVersion = "v3.4.0",
    latestVersion = nil,
    getLatestVersion = getLatestVersion,
    getAppVersion = getAppVersion,
    isUpToDate = isUpToDate
}
return v1
