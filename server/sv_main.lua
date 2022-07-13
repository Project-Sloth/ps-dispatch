QBCore = exports['qb-core']:GetCoreObject()
calls = {}

function _U(entry)
	return Locales[Config.Locale][entry] 
end

function IsPoliceJob(job)
    for k, v in pairs(Config.PoliceJob) do
        if job == v then
            return true
        end
    end
    return false
end
local function GetPlayersJob(job)
	local j = type(job) == "string" and job or tostring(job)
	  local players = {}
    local count = 0
    for src, Player in pairs(QBCore.Functions.GetQBPlayers()) do
        if Player.PlayerData.job.name == j then
	 if Config.onDuty then
		 if Player.PlayerData.job.onduty then
                	players[#players + 1] = src
                	count += 1
           	 end
	 else
	      players[#players + 1] = src
              count += 1
	 end
        end
    end
    return players, count
end

local function SendData(src,job,event,...)
	--check more jobs!
	if GetInvokingResource() == GetCurrentResourceName() then
	local players,count = GetPlayersJob(job)
	for k,v in pairs(players) do
		local el = players[k]
		TriggerClientEvent(event,el,...)
	end
		else
		print("Error Detected "..GetPlayerName(src) .." is trying to send data: "..json.encode({...},{indent=true}).." From resource: "..GetInvokingResource())
	end
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
		
		SendData(source,)
	TriggerClientEvent('dispatch:clNotify', -1, data, newId, source)
    TriggerClientEvent("ps-dispatch:client:AddCallBlip", -1, data.origin, dispatchCodes[data.dispatchcodename])
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
