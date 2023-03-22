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

---@param vehicle number|table Vehicle entity id or vehicle data table 
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the vehicle theft or nil
local function VehicleTheft(vehicle, suspect, coords)
    if not vehicle then print("^1[ps-dispatch]^7 ^3VehicleTheft^7: ^1No vehicle specified^7") return end
    supect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    if type(vehicle) ~= "table" then vehicle = vehicleData(vehicle) end
    local locationInfo = getStreetandZone(coords)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "vehicletheft", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        model = vehicle.name, -- vehicle name
        plate = vehicle.plate, -- vehicle plate
        doorCount = vehicle.doors, -- vehicle door count
        priority = 2,
        firstColor = vehicle.colour, -- vehicle color
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('vehicletheft'),
        job = {"LEO"}
    })
end

exports('VehicleTheft', VehicleTheft)

RegisterNetEvent('dispatch:client:vehicletheft', function(vehicle, coords)
    VehicleTheft(GetEntity(vehicle), PlayerPedId(), coords)
end)

---@param vehicle number|table Vehicle entity id or vehicle data table
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the vehicle shooting or nil
local function VehicleShooting(vehicle, suspect, coords)
    if not vehicle then print("^1[ps-dispatch]^7 ^3VehicleShooting^7: ^1No vehicle specified^7") return end
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    if type(vehicle) ~= "table" then vehicle = vehicleData(vehicle) end
    local locationInfo = getStreetandZone(coords)
    local heading = getCardinalDirectionFromHeading()
    local gender = GetPedGender()
    local CurrentWeapon = GetSelectedPedWeapon(suspect)
    local weapon = WeaponTable[CurrentWeapon] or "UNKNOWN"
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "vehicleshots", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        model = vehicle.name,
        plate = vehicle.plate,
        gender = gender,
        weapon = weapon,
        doorCount = vehicle.doors,
        priority = 2,
        firstColor = vehicle.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('vehicleshots'),
        job = {"LEO"}
    })
end

exports('VehicleShooting', VehicleShooting)

RegisterNetEvent('dispatch:client:vehicleshots', function(vehicle, coords)
    VehicleShooting(GetEntity(vehicle), PlayerPedId(), coords)
end)

---@param suspect number|nil Suspects entity id or nil
---@param coords vector3|nil Location of the shooting or nil
local function Shooting(suspect, coords)
    suspect = shooter or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
    local gender = GetPedGender()
    local CurrentWeapon = GetSelectedPedWeapon(suspect)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('shooting'),
        job = {"LEO"}
    })
end

exports('Shooting', Shooting)

RegisterNetEvent('dispatch:client:shooting', function(coords)
    Shooting(PlayerPedId(), coords)
end)

---@param vehicle number|table Vehicle entity id or vehicle data table
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the speeding vehicle or nil
local function SpeedingVehicle(vehicle, suspect, coords)
    if not vehicle then print("^1[ps-dispatch]^7 ^3SpeedingVehicle^7: ^1No vehicle specified^7") return end
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    if type(vehicle) ~= "table" then vehicle = vehicleData(vehicle) end
    local locationInfo = getStreetandZone(coords)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        model = vehicle.name,
        plate = vehicle.plate,
        doorCount = vehicle.doors,
        priority = 2,
        firstColor = vehicle.colour,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('speeding'),
        job = {"LEO"}
    })
end

exports('SpeedingVehicle', SpeedingVehicle)

RegisterNetEvent('dispatch:client:speeding', function(vehicle, coords)
    SpeedingVehicle(GetEntity(vehicle), PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the fight or nil 
local function Fight(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('melee'),
        job = {"LEO"}
    })
end

exports('Fight', Fight)

RegisterNetEvent('dispatch:client:fight', function(coords)
    Fight(PlayerPedId(), coords)
end)

---@param victim number|nil Victim entity id or nil
---@param coords vector3|nil Location of the injured person or nil
local function InjuriedPerson(victim, coords)
    victim = victim or PlayerPedId()
    coords = coords or GetEntityCoords(victim)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('persondown'), -- message
        job = {"EMS"} -- type or jobs that will get the alerts
    })
end

exports('InjuriedPerson', InjuriedPerson)

RegisterNetEvent('dispatch:client:injuriedperson', function(coords)
    InjuriedPerson(PlayerPedId(), coords)
end)

---@param victim number|nil Victim entity id or nil
---@param coords vector3|nil Location of the dead person or nil
local function DeceasedPerson(victim, coords)
    victim = victim or PlayerPedId()
    coords = coords or GetEntityCoords(victim)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = "Civilian Bled Out", -- message
        job = {"EMS"} -- type or jobs that will get the alerts
    })
end

exports('DeceasedPerson', DeceasedPerson)

RegisterNetEvent('dispatch:client:deceasedperson', function(coords)
    DeceasedPerson(PlayerPedId(), coords)
end)

---@param camId number Camera id
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function StoreRobbery(camId, suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('storerobbery'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('StoreRobbery', StoreRobbery)

RegisterNetEvent('dispatch:client:storerobbery', function(camId, coords)
    StoreRobbery(camId, PlayerPedId(), coords)
end)

---@param camId number Camera id
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function FleecaBankRobbery(camId, suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('fleecabank'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('FleecaBankRobbery', FleecaBankRobbery)

RegisterNetEvent('dispatch:client:fleecabankrobbery', function(camId, coords)
    FleecaBankRobbery(camId, PlayerPedId(), coords)
end)

---@param camId number Camera id
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function PaletoBankRobbery(camId, suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('paletobank'), -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end

exports('PaletoBankRobbery', PaletoBankRobbery)

RegisterNetEvent('dispatch:client:paletobankrobbery', function(camId, coords)
    PaletoBankRobbery(camId, PlayerPedId(), coords)
end)

---@param camId number Camera id
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function PacificBankRobbery(camId, suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('pacificbank'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('PacificBankRobbery', PacificBankRobbery)

RegisterNetEvent('dispatch:client:pacificbankrobbery', function(camId, coords)
    PacificBankRobbery(camId, PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the prison-breakee or nil
local function PrisonBreak(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('prisonbreak'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('PrisonBreak', PrisonBreak)

RegisterNetEvent('dispatch:client:prisonbreak', function(coords)
    PrisonBreak(PlayerPedId(), coords)
end)

---@param camId number Camera id
---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function VangelicoRobbery(camId, suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('vangelico'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('VangelicoRobbery', VangelicoRobbery)

RegisterNetEvent('dispatch:client:vangelicorobbery', function(camId, coords)
    VangelicoRobbery(camId, PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function HouseRobbery(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('houserobbery'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('HouseRobbery', HouseRobbery)

RegisterNetEvent('dispatch:client:houserobbery', function(coords)
    HouseRobbery(PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the robbery or nil
local function YachtHeist(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('yachtheist'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('YachtHeist', YachtHeist)

RegisterNetEvent('dispatch:client:yachtheist', function(coords)
    YachtHeist(PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the sale or nil
local function DrugSale(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('drugsell'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('DrugSale', DrugSale)


-- for rcore_gangs, haven't tested server side exports so made this instead. Remove if you do not need :)
-- edited to work with server events and exports
RegisterNetEvent('dispatch:client:drugsale', function(coords)
    DrugSale(PlayerPedId(), coords)
end)

---@param vehicle number|table Vehicle entity id or vehicle data table
---@param susect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the jacking or nil
local function CarJacking(vehicle, suspect, coords)
    if not vehicle then print("^1[ps-dispatch]^7 ^3CarJacking^7: ^1No vehicle specified^7") return end
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    if type(vehicle) == "number" then vehicle = GetVehiclePedIsIn(PlayerPedId(), false) end
    local locationInfo = getStreetandZone(coords)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify", {
        dispatchcodename = "carjack", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        model = vehicle.name, -- vehicle name
        plate = vehicle.plate, -- vehicle plate
        doorCount = vehicle.doors, -- vehicle doors
        priority = 2,
        firstColor = vehicle.colour, -- vehicle color
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('carjacking'),
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('CarJacking', CarJacking)

RegisterNetEvent('dispatch:client:carjacking', function(vehicle, coords)
    CarJacking(GetEntity(vehicle), PlayerPedId(), coords)
end)

---@param victim number|nil Victim entity id or nil
---@param coords vector3|nil Location of the down or nil
local function OfficerDown(victim, coords)
    victim = victim or PlayerPedId()
    coords = coords or GetEntityCoords(victim)
    local plyData = QBCore.Functions.GetPlayerData()
    local locationInfo = getStreetandZone(coords)
    local callsign = plyData.metadata["callsign"]
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('officerdown'), -- message
        job = {"FirstResponder"} -- type or jobs that will get the alerts
    })
end

exports('OfficerDown', OfficerDown)

RegisterNetEvent("dispatch:client:officerdown", function(coords)
    OfficerDown(PlayerPedId(), coords)
end)

---@param victim number|nil Victim entity id or nil
---@param coords vector3|nil Location of the down or nil
local function EmsDown(victim, coords)
    victim = victim or PlayerPedId()
    coords = coords or GetEntityCoords(victim)
    local plyData = QBCore.Functions.GetPlayerData()
    local locationInfo = getStreetandZone(coords)
    local callsign = plyData.metadata["callsign"]
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('emsdown'), -- message
        job = {"FirstResponder"} -- type or jobs that will get the alerts
    })
end

exports('EmsDown', EmsDown)

RegisterNetEvent("dispatch:client:emsdown", function(coords)
    EmsDown(PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the explosion or nil
local function Explosion(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = "Explosion Reported", -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('Explosion', Explosion)

RegisterNetEvent("dispatch:client:explosion", function(coords)
    Explosion(PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the suspicious activity or nil
local function SuspiciousActivity(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('susactivity'), -- message
        job = {"LEO"} -- type or jobs that will get the alerts
    })
end

exports('SuspiciousActivity', SuspiciousActivity)

RegisterNetEvent("dispatch:client:susactivity", function(coords)
    SuspiciousActivity(PlayerPedId(), coords)
end)

---@param suspect number|nil Suspect entity id or nil
---@param coords vector3|nil Location of the suspected hunter or nil
local function Hunting(suspect, coords)
    suspect = suspect or PlayerPedId()
    coords = coords or GetEntityCoords(suspect)
    local locationInfo = getStreetandZone(coords)
    local gender = GetPedGender()
    local CurrentWeapon = GetSelectedPedWeapon(suspect)
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
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        dispatchMessage = _U('hunting'),
        job = {"LEO"} -- type or jobs that will get the alerts
    })

end

exports('Hunting', Hunting)

RegisterNetEvent("dispatch:client:hunting", function(coords)
    Hunting(PlayerPedId(), coords)
end)

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

RegisterNetEvent("dispatch:client:customalert", function(data)
    CustomAlert(data)
end)