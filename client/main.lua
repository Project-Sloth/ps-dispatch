QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}
inHuntingZone, inNoDispatchZone = false, false
huntingzone, nodispatchzone = nil , nil

local blips = {}
local radius2 = {}
local alertsMuted = false
local alertsDisabled = false
local waypointCooldown = false

-- Functions
---@param bool boolean Toggles visibilty of the menu
local function toggleUI(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({ action = "setVisible", data = bool })
end

local function setupDispatch()
    local playerInfo = QBCore.Functions.GetPlayerData()
    local locales = lib.getLocales()
    PlayerData = {
        charinfo = {
            firstname = playerInfo.charinfo.firstname,
            lastname = playerInfo.charinfo.lastname
        },
        metadata = {
            callsign = playerInfo.metadata.callsign
        },
        citizenid = playerInfo.citizenid,
        job = {
            type = playerInfo.job.type,
            name = playerInfo.job.name,
            label = playerInfo.job.label
        },
    }

    Wait(1000)

    createZones()

    SendNUIMessage({
        action = "setupUI",
        data = {
            locales = locales,
            player = PlayerData,
            keybind = Config.RespondKeybind,
            maxCallList = Config.MaxCallList,
            shortCalls = Config.ShortCalls,
        }
    })
end

---@param data string | table -- The player job or an array of jobs to check against
---@return boolean -- Returns true if the job is valid
local function isJobValid(data)
    local jobType = PlayerData.job.type

    if type(data) == "string" then
        return lib.table.contains(Config.Jobs, data)
    elseif type(data) == "table" then
        return lib.table.contains(data, jobType)
    end

    return false
end

local function openMenu()
    if not isJobValid(PlayerData.job.type) then return end

    local calls = lib.callback.await('ps-dispatch:callback:getCalls', false)
    if #calls == 0 then
        lib.notify({ description = locale('no_calls'), position = 'top', type = 'error' })
    else
        SendNUIMessage({ action = 'setDispatchs', data = calls, })
        toggleUI(true)
    end
end

local function setWaypoint()
    if not isJobValid(PlayerData.job.type) then return end

    local data = lib.callback.await('ps-dispatch:callback:getLatestDispatch', false)

    if not data then return end

    if data.alertTime == nil then data.alertTime = Config.AlertTime end
    local timer = data.alertTime * 1000
    
    if not waypointCooldown and lib.table.contains(data.jobs, PlayerData.job.type) then
        SetNewWaypoint(data.coords.x, data.coords.y)
        TriggerServerEvent('ps-dispatch:server:attach', data.id, PlayerData)
        lib.notify({ description = locale('waypoint_set'), position = 'top', type = 'success' })
        waypointCooldown = true
        SetTimeout(timer, function()
            waypointCooldown = false
        end)
    end
end

local function randomOffset(baseX, baseY, offset)
    local randomX = baseX + math.random(-offset, offset)
    local randomY = baseY + math.random(-offset, offset)

    return randomX, randomY
end

local function createBlipData(coords, radius, sprite, color, scale, flash)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)

    SetBlipFlashes(blip, flash)
    SetBlipSprite(blip, sprite or 161)
    SetBlipHighDetail(blip, true)
    SetBlipScale(blip, scale or 1.0)
    SetBlipColour(blip, color or 84)
    SetBlipAlpha(blip, 255)
    SetBlipAsShortRange(blip, false)
    SetBlipCategory(blip, 2)
    SetBlipColour(radiusBlip, color or 84)
    SetBlipAlpha(radiusBlip, 128)

    return blip, radiusBlip
end

local function createBlip(data, blipData)
    local blip, radius = nil, nil
    local sprite = blipData.sprite or blipData.alert.sprite or 161
    local color = blipData.color or blipData.alert.color or 84
    local scale = blipData.scale or blipData.alert.scale or 1.0
    local flash = blipData.flash or false
    local alpha = 255
    local radiusAlpha = 128
    local blipWaitTime = ((blipData.length or blipData.alert.length) * 60000) / radiusAlpha

    if blipData.offset then
        local offsetX, offsetY = randomOffset(data.coords.x, data.coords.y, Config.MaxOffset)
        blip, radius = createBlipData({ x = offsetX, y = offsetY, z = data.coords.z }, blipData.radius, sprite, color, scale, flash)
        blips[data.id] = blip
        radius2[data.id] = radius
    else
        blip, radius = createBlipData(data.coords, blipData.radius, sprite, color, scale, flash)
        blips[data.id] = blip
        radius2[data.id] = radius
    end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.code .. ' - ' .. data.message)
    EndTextCommandSetBlipName(blip)

    while radiusAlpha > 0 do
        Wait(blipWaitTime)
        radiusAlpha = math.max(0, radiusAlpha - 1)
        SetBlipAlpha(radius, radiusAlpha)
    end

    RemoveBlip(radius)
    RemoveBlip(blip)
end

local function addBlip(data, blipData)
    CreateThread(function()
        createBlip(data, blipData)
    end)
    if not alertsMuted then
        if blipData.sound == "Lose_1st" then
            PlaySound(-1, blipData.sound, blipData.sound2, 0, 0, 1)
        else
            TriggerServerEvent("InteractSound_SV:PlayOnSource", blipData.sound or blipData.alert.sound, 0.25)
        end
    end
end

-- Zone Functions --
function createZones()
    -- Hunting Zone --
    if Config.Locations['HuntingZones'][1] then
    	for _, hunting in pairs(Config.Locations["HuntingZones"]) do
            -- Creates the Blips
            if Config.EnableHuntingBlip then
                local blip = AddBlipForCoord(hunting.coords.x, hunting.coords.y, hunting.coords.z)
                local huntingradius = AddBlipForRadius(hunting.coords.x, hunting.coords.y, hunting.coords.z, hunting.radius)
                SetBlipSprite(blip, 442)
                SetBlipAsShortRange(blip, true)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 0)
                SetBlipColour(huntingradius, 0)
                SetBlipAlpha(huntingradius, 40)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(hunting.label)
                EndTextCommandSetBlipName(blip)
            end
            -- Creates the Sphere --
            huntingzone = lib.zones.sphere({
                coords = hunting.coords,
                radius = hunting.radius,
                debug = Config.Debug,
                onEnter = function()
                    inHuntingZone = true
                end,
                onExit = function()
                    inHuntingZone = false
                end
            })
    	end
    end
    -- No Dispatch Zone --
    if Config.Locations['NoDispatchZones'][1] then
    	for _, nodispatch in pairs(Config.Locations["NoDispatchZones"]) do
            nodispatchzone = lib.zones.box({
                coords = nodispatch.coords,
                size = vec3(nodispatch.length, nodispatch.width, nodispatch.maxZ - nodispatch.minZ),
                rotation = nodispatch.heading,
                debug = Config.Debug,
                onEnter = function()
                    inNoDispatchZone = true
                end,
                onExit = function()
                    inNoDispatchZone = false
                end
            })
    	end
    end
end

local function removeZones()
    -- Hunting Zone --
    huntingzone:remove()
    -- No Dispatch Zone --
    nodispatchzone:remove()
end

-- Keybind
local RespondToDispatch = lib.addKeybind({
    name = 'RespondToDispatch',
    description = 'Set waypoint to last call location',
    defaultKey = Config.RespondKeybind,
    onPressed = setWaypoint,
})

local OpenDispatchMenu = lib.addKeybind({
    name = 'OpenDispatchMenu',
    description = 'Open Dispatch Menu',
    defaultKey = Config.OpenDispatchMenu,
    onPressed = openMenu,
})

-- Events
RegisterNetEvent('ps-dispatch:client:notify', function(data, source)
    if data.alertTime == nil then data.alertTime = Config.AlertTime end
    local timer = data.alertTime * 1000
    
    if alertsDisabled then return end
    if not isJobValid(data.jobs) then return end
    if not IsOnDuty() then return end

    timerCheck = true

    SendNUIMessage({
        action = 'newCall',
        data = {
            data = data,
            timer = timer,
        }
    })

    addBlip(data, Config.Blips[data.codeName] or data)

    RespondToDispatch:disable(false)
    OpenDispatchMenu:disable(true)

    local startTime = GetGameTimer()
    while timerCheck do
        Wait(1000)

        local currentTime = GetGameTimer()
        local elapsed = currentTime - startTime

        if elapsed >= timer then
            break
        end
    end

    timerCheck = false
    OpenDispatchMenu:disable(false)
    RespondToDispatch:disable(true)
end)

RegisterNetEvent('ps-dispatch:client:openMenu', function(data)
    if not isJobValid(PlayerData.job.type) then return end

    if #data == 0 then
        lib.notify({ description = locale('no_calls'), position = 'top', type = 'error' })
    else
        toggleUI(true)
        SendNUIMessage({ action = 'setDispatchs', data = data, })
    end
end)

-- EventHandlers
RegisterNetEvent("QBCore:Client:OnJobUpdate", setupDispatch)

AddEventHandler('QBCore:Client:OnPlayerLoaded', setupDispatch)

AddEventHandler('QBCore:Client:OnPlayerUnload', removeZones)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    setupDispatch()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    removeZones()
end)

-- NUICallbacks
RegisterNUICallback("hideUI", function(_, cb)
    toggleUI(false)
    cb("ok")
end)

RegisterNUICallback("attachUnit", function(data, cb)
    TriggerServerEvent('ps-dispatch:server:attach', data.id, PlayerData)
    SetNewWaypoint(data.coords.x, data.coords.y)
    cb("ok")
end)

RegisterNUICallback("detachUnit", function(data, cb)
    TriggerServerEvent('ps-dispatch:server:detach', data.id, PlayerData)
    DeleteWaypoint()
    cb("ok")
end)

RegisterNUICallback("toggleMute", function(data, cb)
    local muteStatus = data.boolean and locale('muted') or locale('unmuted')
    lib.notify({ description = locale('alerts') .. muteStatus, position = 'top', type = 'warning' })
    alertsMuted = data.boolean
    cb("ok")
end)

RegisterNUICallback("toggleAlerts", function(data, cb)
    local muteStatus = data.boolean and locale('disabled') or locale('enabled')
    lib.notify({ description = locale('alerts') .. muteStatus, position = 'top', type = 'warning' })
    alertsDisabled = data.boolean
    cb("ok")
end)

RegisterNUICallback("clearBlips", function(data, cb)
    lib.notify({ description = locale('blips_cleared'), position = 'top', type = 'success' })
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    for k, v in pairs(radius2) do
        RemoveBlip(v)
    end
    cb("ok")
end)

RegisterNUICallback("refreshAlerts", function(data, cb)
    lib.notify({ description = locale('alerts_refreshed'), position = 'top', type = 'success' })
    local data = lib.callback.await('ps-dispatch:callback:getCalls', false)
    SendNUIMessage({ action = 'setDispatchs', data = data, })
    cb("ok")
end)
