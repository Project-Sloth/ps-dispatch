local QBCore = exports['qb-core']:GetCoreObject()
local calls = {}

function _U(entry)
    return Locales[Config.Locale][entry]
end

local function IsPoliceJob(job)
    for k, v in pairs(Config.PoliceJob) do
        if job == v then
            return true
        end
    end
    return false
end

---This funcion handle the check of players with X job, and will return the source, this will prevent sending the event to everyone in the server, all players donest need to know the notifications (-1)
---@param job string | table
---@return table
local function GetPlayersJob(job)
    local p = promise.new()
    local j = type(job) == "string" and job or type(job) == "table" and job or tostring(job)
    local players = {}
    local isTable = type(job) == "table"

    for src, Player in pairs(QBCore.Functions.GetQBPlayers()) do
        if isTable then -- if jobs are a table then lets run and check it
            for i = 1, #j do
                local el = j[i]
                if Player.PlayerData.job.name == el then
                    if Config.onDuty then
                        if Player.PlayerData.job.onduty then
                            players[#players + 1] = src
                        end
                    else
                        players[#players + 1] = src
                    end
                end
            end
            p:resolve(players)
        else -- if j is only a string lets just return the value and thats it
            if Player.PlayerData.job.name == j then
                if Config.onDuty then
                    if Player.PlayerData.job.onduty then
                        players[#players + 1] = src
                    end
                else
                    players[#players + 1] = src
                end
            end
            p:resolve(players)
        end
    end
    return Citizen.Await(p)
end

function log(text)
    print(json.encode(text, { pretty = true, indent = "  ", align_keys = true }))
end

---Generic function to send data over the net
---@param job table | string
---@param event string
---@param ... unknown
local function SendData(job, event, ...)
    if not type(event) == "string" then return end
    if not job then return end
    local args = { ... }
    local players = GetPlayersJob(job)
    CreateThread(function()
        for i = 1, #players do
            SetTimeout(100, function()
                TriggerClientEvent(event, i, table.unpack(args))
            end)
        end
    end)
end

local function IsDispatchJob(job)
    for k, v in pairs(Config.PoliceAndAmbulance) do
        if job == v then
            return true
        end
    end
    return false
end

RegisterServerEvent("dispatch:server:notify")
AddEventHandler("dispatch:server:notify", function(data)
    local newId = #calls + 1
    calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000
    SendData(data.job, "dispatch:clNotify", data, newId, source)
    SendData(data.job, "ps-dispatch:client:AddCallBlip",
        data.origin, dispatchCodes[data.dispatchcodename], newId)
end)

function GetDispatchCalls() return calls end

exports('GetDispatchCalls', GetDispatchCalls) -- 

-- this is mdt call
AddEventHandler("dispatch:addUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i = 1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
                    cb(#calls[callid]['units'])
                    return
                end
            end
        end

        if IsPoliceJob(player.job.name) then
            calls[callid]['units'][#calls[callid]['units'] + 1] = { cid = player.cid, fullname = player.fullname,
                job = 'Police', callsign = player.callsign }
        elseif player.job.name == 'ambulance' then
            calls[callid]['units'][#calls[callid]['units'] + 1] = { cid = player.cid, fullname = player.fullname,
                job = 'EMS', callsign = player.callsign }
        end
        cb(#calls[callid]['units'])
    end
end)

AddEventHandler("dispatch:sendCallResponse", function(player, callid, message, time, cb)
    local Player = QBCore.Functions.GetPlayer(player)
    local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    if calls[callid] then
        calls[callid]['responses'][#calls[callid]['responses'] + 1] = {
            name = name,
            message = message,
            time = time
        }
        local player = calls[callid]['source']
        if GetPlayerPing(player) > 0 then
            TriggerClientEvent('dispatch:getCallResponse', player, message)
        end
        cb(true)
    else
        cb(false)
    end
end)

-- this is mdt call
AddEventHandler("dispatch:removeUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i = 1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
                    calls[callid]['units'][i] = nil
                end
            end
        end
        cb(#calls[callid]['units'])
    end
end)


RegisterCommand('togglealerts', function(source, args, user)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local job = Player.PlayerData.job
    if IsPoliceJob(job.name) or job.name == 'ambulance' then
        TriggerClientEvent('dispatch:manageNotifs', source, args[1])
    end
end)

-- Explosion Handler
local ExplosionCooldown = false
AddEventHandler('explosionEvent', function(source, info)
    if ExplosionCooldown then return end

    for i = 1, (#Config.ExplosionTypes) do
        if info.explosionType == Config.ExplosionTypes[i] then
            TriggerClientEvent("ps-dispatch:client:Explosion", source)
            ExplosionCooldown = true
            SetTimeout(1500, function()
                ExplosionCooldown = false
            end)
        end
    end
end)

QBCore.Commands.Add("cleardispatchblips", "Clear all dispatch blips", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local job = Player.PlayerData.job.name
    if IsDispatchJob(job) then
        TriggerClientEvent('ps-dispatch:client:clearAllBlips', src)
    end
end)

-- RegisterCommand("jerico", function(source, args)
--     print(json.encode(args, { indent = true }))
--     print(json.encode(SendData(source, { "police" }, "QBCore:Notify", { source, "HOLAAAA" })))

-- end)
