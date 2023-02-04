Core = nil

if Config.Core == "QBCore" then Core = exports['qb-core']:GetCoreObject()
elseif Config.Core == "ESX" then Core = exports['es_extended']:getSharedObject() end

Functions = {}

Functions.QBCore = {}
Functions.QBCore.GetPlayer = function(src)
    return Core.Functions.GetPlayer(src)
end
Functions.QBCore.GetName = function(player)
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end
Functions.QBCore.GetJob = function(player)
    return player.PlayerData.job
end
Functions.QBCore.RegisterCommand = function(name, help, args, argsReq, cb)
    Core.Commands.Add(name, help, args, argsReq, function(source, ...)
        local player = Core.Functions.GetPlayer(source)
        cb(player, ...)
    end)
end

Functions.ESX = {}
Functions.ESX.GetPlayer = function(src)
    return Core.GetPlayerFromId(src)
end
Functions.ESX.GetName = function(player)
    return player.getName()
end
Functions.ESX.GetJob = function(player)
    return player.getJob()
end
Functions.ESX.RegisterCommand = function(name, help, args, argsReq, cb)
    Core.RegisterCommand(name, 'user', cb, argsReq, {help = help, arguments = args})
end

if Config.Core == "ESX" then
    Core.RegisterServerCallback('ps-dispatch:server:esx:getPlayerName', function(src, cb)
        local player = Functions.ESX.GetPlayer(src)
        if not player then return cb('', '') end

        local rawName = Functions.ESX.GetName(player) or ""
        local name = rawName:gmatch("%S+")
        local firstname = nil
        local lastname = nil

        local i = 0
        for token in name do
            if i == 0 then firstname = token
            elseif i == 1 then lastname = token
            else break end

            i = i + 1
        end
        
        firstname = firstname or ""
        lastname = lastname or ""

        cb(firstname, lastname)
    end)
end