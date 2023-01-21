local QBCore = exports['qb-core']:GetCoreObject()
local calls = {}

function _U(entry)
	return Locales[Config.Locale][entry] 
end

local function IsPoliceJob(job)
    local PoliceJobs = Config.AuthorizedJobs.LEO.Jobs
    for k, v in pairs(PoliceJobs) do
        if job == v then
            return true
        end
    end
    return false
end

local function IsDispatchJob(job)
    local PoliceJobs = Config.AuthorizedJobs.LEO.Jobs
    local AmbulanceJobs = Config.AuthorizedJobs.EMS.Jobs
    for k, v in pairs(PoliceJobs) do
        if job == v then
            return true
        end
    end
    for k, v in pairs(AmbulanceJobs) do
        if job == v then
            return true
        end
    end
    return false
end

RegisterServerEvent("dispatch:server:notify", function(data)
	local newId = #calls + 1
	calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000

	TriggerClientEvent('dispatch:clNotify', -1, data, newId, source)
    if not data.alert then 
        TriggerClientEvent("ps-dispatch:client:AddCallBlip", -1, data.origin, dispatchCodes[data.dispatchcodename], newId)
    else
        TriggerClientEvent("ps-dispatch:client:AddCallBlip", -1, data.origin, data.alert, newId)
    end
end)

function GetDispatchCalls() return calls end
exports('GetDispatchCalls', GetDispatchCalls) -- 

-- this is mdt call
AddEventHandler("dispatch:addUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
                    cb(#calls[callid]['units'])
                    return
                end
            end
        end

        if IsPoliceJob(player.job.name) then
            calls[callid]['units'][#calls[callid]['units']+1] = { cid = player.cid, fullname = player.fullname, job = 'Police', callsign = player.callsign }
        elseif player.job.name == 'ambulance' then
            calls[callid]['units'][#calls[callid]['units']+1] = { cid = player.cid, fullname = player.fullname, job = 'EMS', callsign = player.callsign }
        end
        cb(#calls[callid]['units'])
    end
end)

AddEventHandler("dispatch:sendCallResponse", function(player, callid, message, time, cb)
    local Player = QBCore.Functions.GetPlayer(player)
    local name = Player.PlayerData.charinfo.firstname.. " " ..Player.PlayerData.charinfo.lastname
    if calls[callid] then
        calls[callid]['responses'][#calls[callid]['responses']+1] = {
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
            for i=1, #calls[callid]['units'] do
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
