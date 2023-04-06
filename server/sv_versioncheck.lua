local function versionCheck(repo)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resource, 'version', 0)
    if not currentVersion then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resource)) end
    currentVersion = currentVersion:match('%d+%.%d+%.%d+')
    local check = promise.new()
    PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(repo), function(status, response)
        if status ~= 200 then return end
        response = json.decode(response)
        if response.prerelease then return end
        local latestVersion = response.tag_name:match('%d+%.%d+%.%d+')
        if not latestVersion or latestVersion == currentVersion then return end
        local cv, lv = currentVersion:gsub('%D', ''), latestVersion:gsub('%D', '')
        if cv < lv then check:resolve({resource = resource, currentVersion = currentVersion, response = response}) end
    end, 'GET')
    return check
end

versionCheck('Project-Sloth/ps-dispatch'):next(function(data)
    SetTimeout(1000, function()
        print("^0.-----------------------------------------------.")
        print("^0|                 Project Sloth                 |")
        print("^0'-----------------------------------------------'")
        print(('^6Your %s is outdated (your version: %s)\r\nMake sure to update: %s^0'):format(data.resource, data.currentVersion, data.response.html_url))
        print('^2'..data.response.body:gsub("\r\n\r\n\r", "^0"))
    end)
end)