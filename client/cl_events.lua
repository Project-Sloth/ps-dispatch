local WeaponTable = {
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
local function VehicleTheft(vehicle)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "vehicletheft", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        model = vehdata.name, -- vehicle name
        plate = vehdata.plate, -- vehicle plate
        priority = 2,
        firstColor = vehdata.colour, -- vehicle color
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('vehicletheft'),
        job = {"LEO", "police"}
    })
end

exports('VehicleTheft', VehicleTheft)

local function VehicleShooting(vehdata)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    local gender = GetPedGender()
    local doorCount = 0

    local PlayerPed = PlayerPedId()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
    local weapon = WeaponTable[CurrentWeapon] or "UNKNOWN"
    if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
    if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end
    if doorCount == 2 then doorCount = "Two-Door" elseif doorCount == 3 then doorCount = "Three-Door" elseif doorCount == 4 then doorCount = "Four-Door" else doorCount = "UNKNOWN" end
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "vehicleshots", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        model = vehdata.name,
        plate = vehdata.plate,
        gender = gender,
        weapon = weapon,
        doorCount = doorCount,
        priority = 2,
        firstColor = vehdata.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('vehicleshots'),
        job = {"LEO", "police"}
    })
end

exports('VehicleShooting', VehicleShooting)


local function Shooting()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local PlayerPed = PlayerPedId()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
    local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936) .. " MPH" -- * 3.6 = KMH    /    * 2.236936 = MPH
    local weapon = WeaponTable[CurrentWeapon] or "UNKNOWN"

    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "shooting", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        gender = gender,
        weapon = weapon,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('shooting'),
        job = {"LEO", "police"}
    })

end

exports('Shooting', Shooting)

local function SpeedingVehicle(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        model = vehdata.name,
        plate = vehdata.plate,
        priority = 2,
        firstColor = vehdata.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('speeding'),
        job = {"LEO", "police"}
    })
end

exports('SpeedingVehicle', SpeedingVehicle)

local function Fight()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "fight", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-10",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('melee'),
        job = {"LEO", "police"}
    })
end

exports('Fight', Fight)

local function InjuriedPerson()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "civdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-69",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('persondown'), -- message
        job = {"EMS", "ambulance"} -- type or jobs that will get the alerts
    })
end

exports('InjuriedPerson', InjuriedPerson)

local function DeceasedPerson()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "civdead", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-69",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Civilian Bled Out", -- message
        job = {"EMS", "ambulance"} -- type or jobs that will get the alerts
    })
end

exports('DeceasedPerson', DeceasedPerson)

local function StoreRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "storerobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('storerobbery'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('StoreRobbery', StoreRobbery)

local function FleecaBankRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "bankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('fleecabank'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "paletobankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('paletobank'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('PaletoBankRobbery', PaletoBankRobbery)

local function PacificBankRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "pacificbankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('pacificbank'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('PacificBankRobbery', PacificBankRobbery)

local function PrisonBreak()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "prisonbreak", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('prisonbreak'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('PrisonBreak', PrisonBreak)

local function VangelicoRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "vangelicorobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        camId = camId,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('vangelico'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('VangelicoRobbery', VangelicoRobbery)

local function HouseRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "houserobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('houserobbery'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('HouseRobbery', HouseRobbery)

local function YachtHeist()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "yachtheist", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-65",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('yachtheist'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('YachtHeist', YachtHeist)

local function DrugSale()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "suspicioushandoff", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-13",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('drugsell'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('DrugSale', DrugSale)


-- for rcore_gangs, haven't tested server side exports so made this instead. Remove if you do not need :)
RegisterNetEvent('ps-dispatch:client:drugsale', function()
    DrugSale()
end)

local function CarJacking(vehicle)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "carjack", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        model = vehdata.name, -- vehicle name
        plate = vehdata.plate, -- vehicle plate
        priority = 2,
        firstColor = vehdata.colour, -- vehicle color
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('carjacking'),
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('CarJacking', CarJacking)

local function OfficerDown()
    local plyData = QBCore.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local callsign = QBCore.Functions.GetPlayerData().metadata["callsign"]
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "officerdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = "COP - " .. plyData.charinfo.firstname:sub(1, 1):upper() .. plyData.charinfo.firstname:sub(2) .. " " .. plyData.charinfo.lastname:sub(1, 1):upper() .. plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        callsign = callsign,
        priority = 1, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('officerdown'), -- message
        job = {"FirstResponder", "ambulance"} -- type or jobs that will get the alerts
    })
end

exports('OfficerDown', OfficerDown)

RegisterNetEvent("ps-dispatch:client:officerdown", function ()
    OfficerDown()
end)

local function EmsDown()
    local plyData = QBCore.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local callsign = QBCore.Functions.GetPlayerData().metadata["callsign"]
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "emsdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = "EMS - " .. plyData.charinfo.firstname:sub(1, 1):upper() .. plyData.charinfo.firstname:sub(2) .. " " .. plyData.charinfo.lastname:sub(1, 1):upper() .. plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        callsign = callsign,
        priority = 1, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('emsdown'), -- message
        job = {"FirstResponder", "ambulance"} -- type or jobs that will get the alerts
    })
end

exports('EmsDown', EmsDown)

RegisterNetEvent("ps-dispatch:client:emsdown", function ()
    EmsDown()
end)

local function Explosion()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "explosion", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-80",
        firstStreet = locationInfo,
        gender = nil,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Explosion Reported", -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('Explosion', Explosion)

local function SuspiciousActivity()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "susactivity", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-66",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('susactivity'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('SuspiciousActivity', SuspiciousActivity)

local function Hunting()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local PlayerPed = PlayerPedId()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
    local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936) .. " MPH" -- * 3.6 = KMH    /    * 2.236936 = MPH
    local weapon = WeaponTable[CurrentWeapon] or "UNKNOWN"

    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "hunting", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-13",
        firstStreet = locationInfo,
        gender = gender,
        weapon = weapon,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = _U('hunting'),
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })

end

exports('Hunting', Hunting)

local function CustomAlert(data)

    local coords = data.coords or vec3(0.0, 0.0, 0.0)
    local gender = GetPedGender()
    if not data.gender then gender = nil end 
    local job = {"LEO", "police"}
    if data.job then job = data.job end


    local locationInfo = getStreetandZone(coords)
    TriggerServerEvent("dispatch:server:notify", {
        dispatchCode = data.dispatchCode or "NONE", 
        firstStreet = locationInfo,
        gender = gender,
        model = data.model or nil,
        plate = data.plate or nil,
        priority = data.priority or 2, -- priority
        firstColor = data.firstColor or nil,
        camId = data.camId or nil,
        callsign = data.callsign or nil,
        name = data.name or nil,
        doorCount = data.doorCount or nil,
        heading = data.heading or nil,
        automaticGunfire = data.automaticGunfire or false,
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = data.message or "", 
        job = job,
        alert = {
            displayCode = data.dispatchCode or "NONE", 
            description = data.description or "", 
            radius = data.radius or 0, 
            recipientList = job, 
            blipSprite = data.sprite or 1, 
            blipColour = data.color or 1, 
            blipScale = data.scale or 0.5, 
            blipLength = data.length or 2, 
            sound = data.sound or "Lose_1st", 
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset", 
            offset = data.offset or "false", 
            blipflash = data.flash or "false"
        }
    })
end
exports('CustomAlert', CustomAlert)
