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

RegisterServerEvent("dispatch:server:notify")
AddEventHandler("dispatch:server:notify", function(data)
	local newId = #calls + 1
	calls[newId] = data
    calls[newId]['source'] = source
    calls[newId]['callId'] = newId
    calls[newId]['units'] = {}
    calls[newId]['responses'] = {}
    calls[newId]['time'] = os.time() * 1000

	TriggerClientEvent('dispatch:clNotify', -1, data, newId, source)
    TriggerClientEvent("qb-dispatch:client:AddCallBlip", -1, data.origin, dispatchCodes[data.dispatchcodename])
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
            table.insert(calls[callid]['units'], { cid = player.cid, fullname = player.fullname, job = 'Police', callsign = player.callsign })
        elseif player.job.name == 'ambulance' then
            table.insert(calls[callid]['units'], { cid = player.cid, fullname = player.fullname, job = 'EMS', callsign = player.callsign })
        end
        cb(#calls[callid]['units'])
    end
end)

-- this is mdt call
AddEventHandler("dispatch:removeUnit", function(callid, player, cb)
    if calls[callid] then
        if #calls[callid]['units'] > 0 then
            for i=1, #calls[callid]['units'] do
                if calls[callid]['units'][i]['cid'] == player.cid then
                    table.remove(calls[callid]['units'], i)
                end
            end
        end
        cb(#calls[callid]['units'])
    end    
end)