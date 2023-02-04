Core = nil

if Config.Core == "QBCore" then Core = exports['qb-core']:GetCoreObject()
elseif Config.Core == "ESX" then Core = exports['es_extended']:getSharedObject() end

Functions = {}

-- QBCore
Functions.QBCore = {}
Functions.QBCore.GetPlayerData = function()
    return Core.Functions.GetPlayerData()
end
Functions.QBCore.GetGender = function(playerData)
    return playerData.charinfo.gender
end
Functions.QBCore.GetOnDuty = function(playerData)
    return playerData.job.onduty
end
Functions.QBCore.Notify = function(...)
    Core.Functions.Notify(...)
end
Functions.QBCore.GetName = function(playerData)
    return playerData.charinfo.firstname, playerData.charinfo.lastname
end
Functions.QBCore.HasPhone = function()
    return Core.Functions.HasItem("phone")
end
Functions.QBCore.GetPhoneNumber = function(playerData)
    return playerData.charinfo.phone
end
Functions.QBCore.GetCallSign = function(playerData)
    return playerData.metadata["callsign"]
end
Functions.QBCore.IsHandcuffed = function()
    return exports['qb-policejob']:IsHandcuffed()
end

-- ESX
Functions.ESX = {}
Functions.ESX.GetPlayerData = function()
    return Core.PlayerData
end
Functions.ESX.GetGender = function(playerData)
    return playerData.sex == "m" and 0 or 1
end
Functions.ESX.GetOnDuty = function()
    return true
end
Functions.ESX.Notify = function(...)
    Core.ShowNotification(...)
end
Functions.ESX.GetName = function(playerData)
    return playerData.firstName, playerData.lastName
end
Functions.ESX.HasPhone = function()
    return true
end
Functions.ESX.GetPhoneNumber = function()
    return ''
end
Functions.ESX.GetCallSign = function()
    return ''
end
Functions.ESX.IsHandcuffed = function()
    return false
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        isLoggedIn = true
        PlayerData = Functions[Config.Core].GetPlayerData()
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    PlayerData = Functions[Config.Core].GetPlayerData()
    PlayerJob = PlayerData.job
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    isLoggedIn = false
    currentCallSign = ""
    -- currentVehicle, inVehicle, currentlyArmed, currentWeapon = nil, false, false, `WEAPON_UNARMED`
    -- removeHuntingZones()
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    PlayerData = Functions[Config.Core].GetPlayerData()
    PlayerJob = JobInfo
end)

AddEventHandler('esx:setPlayerData', function(key, val, last)
    if GetInvokingResource() == 'es_extended' then
        Core.PlayerData[key] = val
        PlayerJob = Core.PlayerData.job
    end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    Core.PlayerData = xPlayer
    Core.PlayerLoaded = true
    isLoggedIn = true
    PlayerJob = xPlayer.job
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    Core.PlayerLoaded = false
    Core.PlayerData = {}
    isLoggedIn = false
end)