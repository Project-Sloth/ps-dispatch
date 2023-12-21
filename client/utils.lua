function GetPlayerHeading()
    local heading = GetEntityHeading(cache.ped)

    if heading >= 315 or heading < 45 then
        return locale('north')
    elseif heading >= 45 and heading < 135 then
        return locale('west')
    elseif heading >= 135 and heading < 225 then
        return locale('south')
    elseif heading >= 225 and heading < 315 then
        return locale('east')
    end
end

function GetPlayerGender()
    return PlayerData.charinfo.gender == 1 and 'Female' or 'Male'
end

function GetIsHandcuffed()
    return QBCore.Functions.GetPlayerData()?.metadata?.ishandcuffed
end

function IsOnDuty()
    if Config.OnDutyOnly then
        if QBCore.Functions.GetPlayerData().job.onduty then
            return true
        else
            return false
        end
    end
    return true
end

---@return boolean
local function HasPhone()
    for _, item in ipairs(Config.PhoneItems) do
        if QBCore.Functions.HasItem(item) then
            return true
        end
    end
    return false
end

---@param coords table
---@return string
function GetStreetAndZone(coords)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    return street .. ", " .. zone
end

---@param vehicle string
---@return string
local function getVehicleColor(vehicle)
    local vehicleColor1, vehicleColor2 = GetVehicleColor(vehicle)
    local color1 = Config.Colors[tostring(vehicleColor1)]
    local color2 = Config.Colors[tostring(vehicleColor2)]

    if color1 and color2 then
        return color2 .. " on " .. color1
    elseif color1 then
        return color1
    elseif color2 then
        return color2
    else
        return "Unknown"
    end
end

---@param vehicle string
---@return string
local function getVehicleDoors(vehicle)
    local doorCount = 0

    if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end

    if doorCount == 2 then
        doorCount = locale('two_door')
    elseif doorCount == 3 then
        doorCount = locale('three_door')
    elseif doorCount == 4 then
        doorCount = locale('four_door')
    else
        doorCount = 'unknown'
    end

    return doorCount
end

---@param vehicle string
---@return table
function GetVehicleData(vehicle)
    local data = {}

    local vehicleClass = {
        [0] = locale('compact'),
        [1] = locale('sedan'),
        [2] = locale('suv'),
        [3] = locale('coupe'),
        [4] = locale('muscle'),
        [5] = locale('sports_classic'),
        [6] = locale('sports'),
        [7] = locale('super'),
        [8] = locale('motorcycle'),
        [9] = locale('offroad'),
        [10] = locale('industrial'),
        [11] = locale('utility'),
        [12] = locale('van'),
        [17] = locale('service'),
        [19] = locale('military'),
        [20] = locale('truck')
    }

    data.class = vehicleClass[GetVehicleClass(vehicle)] or "Unknown"
    data.name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    data.plate = GetVehicleNumberPlateText(vehicle)
    data.doors = getVehicleDoors(vehicle)
    data.color = getVehicleColor(vehicle)
    data.id = NetworkGetNetworkIdFromEntity(vehicle)

    return data
end

function PhoneAnimation()
    lib.requestAnimDict("cellphone@in_car@ds", 500)

    if not IsEntityPlayingAnim(cache.ped, "cellphone@in_car@ds", "cellphone_call_listen_base", 3) then
        TaskPlayAnim(cache.ped, "cellphone@in_car@ds", "cellphone_call_listen_base", 3.0, 3.0, -1, 50, 0, false, false, false)
    end

    Wait(2500)
    StopEntityAnim(cache.ped, "cellphone_call_listen_base", "cellphone@in_car@ds", 3)
end

---@param message string
---@return boolean
function IsCallAllowed(message)
    local msgLength = string.len(message)

    if msgLength == 0 then return false end
    if GetIsHandcuffed() then return false end
    if Config.PhoneRequired and not HasPhone() then QBCore.Functions.Notify('You need a communications device for this.', 'error', 5000) return false end

    return true
end

local weaponTable = {
    [584646201]   = "CLASS 2: AP-Pistol",
    [453432689]   = "CLASS 1: Pistol",
    [3219281620]  = "CLASS 1: Pistol MK2",
    [1593441988]  = "CLASS 1: Combat Pistol",
    [-1716589765] = "CLASS 1: Heavy Pistol",
    [-1076751822] = "CLASS 1: SNS-Pistol",
    [-771403250]  = "CLASS 2: Desert Eagle",
    [137902532]   = "CLASS 2: Vintage Pistol",
    [-598887786]  = "CLASS 2: Marksman Pistol",
    [-1045183535] = "CLASS 2: Revolver",
    [911657153]   = "Taser",
    [324215364]   = "CLASS 2: Micro-SMG",
    [-619010992]  = "CLASS 2: Machine-Pistol",
    [736523883]   = "CLASS 2: SMG",
    [2024373456]  = "CLASS 2: SMG MK2",
    [-270015777]  = "CLASS 2: Assault SMG",
    [171789620]   = "CLASS 2: Combat PDW",
    [-1660422300] = "CLASS 4: Combat MG",
    [3686625920]  = "CLASS 4: Combat MG MK2",
    [1627465347]  = "CLASS 4: Gusenberg",
    [-1121678507] = "CLASS 2: Mini SMG",
    [-1074790547] = "CLASS 3: Assaultrifle",
    [961495388]   = "CLASS 3: Assaultrifle MK2",
    [-2084633992] = "CLASS 3: Carbinerifle",
    [4208062921]  = "CLASS 3: Carbinerifle MK2",
    [-1357824103] = "CLASS 3: Advancedrifle",
    [-1063057011] = "CLASS 3: Specialcarbine",
    [2132975508]  = "CLASS 3: Bulluprifle",
    [1649403952]  = "CLASS 3: Compactrifle",
    [100416529]   = "CLASS 4: Sniperrifle",
    [205991906]   = "CLASS 4: Heavy Sniper",
    [177293209]   = "CLASS 4: Heavy Sniper MK2",
    [-952879014]  = "CLASS 4: Marksmanrifle",
    [487013001]   = "CLASS 2: Pumpshotgun",
    [2017895192]  = "CLASS 2: Sawnoff Shotgun",
    [-1654528753] = "CLASS 3: Bullupshotgun",
    [-494615257]  = "CLASS 3: Assaultshotgun",
    [-1466123874] = "CLASS 3: Musket",
    [984333226]   = "CLASS 3: Heavyshotgun",
    [-275439685]  = "CLASS 2: Doublebarrel Shotgun",
    [317205821]   = "CLASS 2: Autoshotgun",
    [-1568386805] = "CLASS 5: GRENADE LAUNCHER",
    [-1312131151] = "CLASS 5: RPG",
    [125959754]   = "CLASS 5: Compactlauncher"
}

function GetWeaponName()
    local currentWeapon = GetSelectedPedWeapon(cache.ped)
    return weaponTable[currentWeapon] or "Unknown"
end
