-----------------------------------------------------
---------------- Created for you by -----------------
-------------- NightRider & SG Studios  -------------
-----------------------------------------------------

local curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = GetCurrentResourceName()

if not Config.checkForUpdates then
    return
end

local GITHUB_API = "https://api.github.com/repos/NR-Developments/sg-slashtire/releases/latest"
local GITHUB_URL = "https://github.com/NR-Developments/sg-slashtire"

local function fetchLatestVersion(callback)
    PerformHttpRequest(GITHUB_API, function(status, body)
        if status ~= 200 then
            print(("^0[^3WARNING^0] [%s] Unable to check for updates (HTTP %s)."):format(resourceName, status))
            callback(nil, nil, nil)
            return
        end

        local data = json.decode(body)
        if not data or not data.tag_name then
            print(("^0[^3WARNING^0] [%s] Invalid GitHub release data."):format(resourceName))
            callback(nil, nil, nil)
            return
        end

        local repoVersion = tostring(data.tag_name)
        local repoURL = tostring(data.html_url or GITHUB_URL)
        local repoBody = tostring(data.body or "No changelog provided.")

        callback(repoVersion, repoURL, repoBody)
    end, "GET")
end

local function compareVersions(localVer, remoteVer)
    -- Normalize versions (remove leading 'v', spaces, etc.)
    localVer = tostring(localVer):gsub("[^0-9%.]", "")
    remoteVer = tostring(remoteVer):gsub("[^0-9%.]", "")

    -- Split into numeric components
    local function split(ver)
        local t = {}
        for num in ver:gmatch("(%d+)") do
            t[#t+1] = tonumber(num)
        end
        return t
    end

    local l = split(localVer)
    local r = split(remoteVer)

    -- Compare each segment
    for i = 1, math.max(#l, #r) do
        local lv = l[i] or 0
        local rv = r[i] or 0
        if lv < rv then return false end
        if lv > rv then return true end
    end

    return true -- equal versions
end

CreateThread(function()
    Wait(2000) -- allow resource metadata to load

    fetchLatestVersion(function(repoVersion, repoURL, repoBody)
        if not repoVersion then
            return -- already handled above
        end

        if compareVersions(curVersion, repoVersion) then
            print(("^0[^2INFO^0] [%s] is up to date! (^2%s^0)"):format(resourceName, curVersion))
        else
            print(("^0[^3WARNING^0] [%s] is ^1NOT^0 up to date!"):format(resourceName))
            print(("^0[^3WARNING^0] Your Version: ^2%s^0"):format(curVersion))
            print(("^0[^3WARNING^0] Latest Version: ^2%s^0"):format(repoVersion))
            print(("^0[^3WARNING^0] Get the latest Version from: ^2%s^0"):format(repoURL))
            print("^0[^3WARNING^0] Changelog:^0")
            print("^1" .. repoBody .. "^0")
        end
    end)
end)

