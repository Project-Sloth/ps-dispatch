local function VehicleTheft(vehicle)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Vehicle Theft",
        job = {"police"}
    })
end exports('VehicleTheft', VehicleTheft)

local function VehicleShooting(vehdata)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    local gender = GetPedGender()
    local doorCount = 0
    local weapon = nil
    local PlayerPed = PlayerPedId()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
    if CurrentWeapon == 584646201 then weapon = "CLASS 2: AP-Pistol" elseif CurrentWeapon == 453432689 then weapon = "CLASS 1: Pistol" elseif CurrentWeapon == 3219281620 then weapon = "CLASS 1: Pistol MK2" elseif CurrentWeapon == 1593441988 then weapon = "CLASS 1: Combat Pistol" elseif CurrentWeapon == -1716589765 then weapon = "CLASS 1: Heavy Pistol" elseif CurrentWeapon == -1076751822 then weapon = "CLASS 1: SNS-Pistol" elseif CurrentWeapon == -771403250 then weapon = "CLASS 2: Desert Eagle" elseif CurrentWeapon == 137902532 then weapon = "CLASS 2: Vintage Pistol" elseif CurrentWeapon == -598887786 then weapon = "CLASS 2: Marksman Pistol" elseif CurrentWeapon == -1045183535 then weapon = "CLASS 2: Revolver" elseif CurrentWeapon == 911657153 then weapon = "Taser" elseif CurrentWeapon == 324215364 then weapon = "CLASS 2: Micro-SMG" elseif CurrentWeapon == -619010992 then weapon = "CLASS 2: Machine-Pistol" elseif CurrentWeapon == 736523883 then weapon = "CLASS 2: SMG" elseif CurrentWeapon == 2024373456 then weapon = "CLASS 2: SMG MK2" elseif CurrentWeapon == -270015777 then weapon = "CLASS 2: Assault SMG" elseif CurrentWeapon == 171789620 then weapon = "CLASS 2: Combat PDW" elseif CurrentWeapon == -1660422300 then weapon = "CLASS 4: MG" elseif CurrentWeapon == -1660422300 then weapon = "CLASS 4: Combat MG" elseif CurrentWeapon == 3686625920 then weapon = "CLASS 4: Combat MG MK2" elseif CurrentWeapon == 1627465347 then weapon = "CLASS 4: Gusenberg" elseif CurrentWeapon == -1121678507 then weapon = "CLASS 2: Mini SMG" elseif CurrentWeapon == -1074790547 then weapon = "CLASS 3: Assaultrifle" elseif CurrentWeapon == 961495388 then weapon = "CLASS 3: Assaultrifle MK2" elseif CurrentWeapon == -2084633992 then weapon = "CLASS 3: Carbinerifle" elseif CurrentWeapon == 4208062921 then weapon = "CLASS 3: Carbinerifle MK2" elseif CurrentWeapon == -1357824103 then weapon = "CLASS 3: Advancedrifle" elseif CurrentWeapon == -1063057011 then weapon = "CLASS 3: Specialcarbine" elseif CurrentWeapon == 2132975508 then weapon = "CLASS 3: Bulluprifle" elseif CurrentWeapon == 1649403952 then weapon = "CLASS 3: Compactrifle" elseif CurrentWeapon == 100416529 then weapon = "CLASS 4: Sniperrifle" elseif CurrentWeapon == 205991906 then weapon = "CLASS 4: Heavy Sniper" elseif CurrentWeapon == 177293209 then weapon = "CLASS 4: Heavy Sniper MK2" elseif CurrentWeapon == -952879014 then weapon = "CLASS 4: Marksmanrifle" elseif CurrentWeapon == 487013001 then weapon = "CLASS 2: Pumpshotgun" elseif CurrentWeapon == 2017895192 then weapon = "CLASS 2: Sawnoff Shotgun" elseif CurrentWeapon == -1654528753 then weapon = "CLASS 3: Bullupshotgun" elseif CurrentWeapon == -494615257 then weapon = "CLASS 3: Assaultshotgun" elseif CurrentWeapon == -1466123874 then weapon = "CLASS 3: Musket" elseif CurrentWeapon == 984333226 then weapon = "CLASS 3: Heavyshotgun" elseif CurrentWeapon == -275439685 then weapon = "CLASS 2: Doublebarrel Shotgun" elseif CurrentWeapon == 317205821 then weapon = "CLASS 2: Autoshotgun" elseif CurrentWeapon == -1568386805 then weapon = "CLASS 5: GRENADE LAUNCHER" elseif CurrentWeapon == -1312131151 then weapon = "CLASS 5: RPG" elseif CurrentWeapon == 125959754 then weapon = "CLASS 5: Compactlauncher" else weapon = "UNKNOWN" end
	if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end
	if doorCount == 2 then doorCount = "Two-Door" elseif doorCount == 3 then doorCount = "Three-Door" elseif doorCount == 4 then doorCount = "Four-Door" else doorCount = "UNKNOWN" end
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Shots Fired from Vehicle",
        job = {"police"}
    })
end exports('VehicleShooting', VehicleShooting)

local function Shooting()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local PlayerPed = PlayerPedId()
    local weapon = nil
    local PlayerPed = PlayerPedId()
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPed)
    local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936).. " MPH"  -- * 3.6 = KMH    /    * 2.236936 = MPH
    if CurrentWeapon == 584646201 then weapon = "CLASS 2: AP-Pistol" elseif CurrentWeapon == 453432689 then weapon = "CLASS 1: Pistol" elseif CurrentWeapon == 3219281620 then weapon = "CLASS 1: Pistol MK2" elseif CurrentWeapon == 1593441988 then weapon = "CLASS 1: Combat Pistol" elseif CurrentWeapon == -1716589765 then weapon = "CLASS 1: Heavy Pistol" elseif CurrentWeapon == -1076751822 then weapon = "CLASS 1: SNS-Pistol" elseif CurrentWeapon == -771403250 then weapon = "CLASS 2: Desert Eagle" elseif CurrentWeapon == 137902532 then weapon = "CLASS 2: Vintage Pistol" elseif CurrentWeapon == -598887786 then weapon = "CLASS 2: Marksman Pistol" elseif CurrentWeapon == -1045183535 then weapon = "CLASS 2: Revolver" elseif CurrentWeapon == 911657153 then weapon = "Taser" elseif CurrentWeapon == 324215364 then weapon = "CLASS 2: Micro-SMG" elseif CurrentWeapon == -619010992 then weapon = "CLASS 2: Machine-Pistol" elseif CurrentWeapon == 736523883 then weapon = "CLASS 2: SMG" elseif CurrentWeapon == 2024373456 then weapon = "CLASS 2: SMG MK2" elseif CurrentWeapon == -270015777 then weapon = "CLASS 2: Assault SMG" elseif CurrentWeapon == 171789620 then weapon = "CLASS 2: Combat PDW" elseif CurrentWeapon == -1660422300 then weapon = "CLASS 4: MG" elseif CurrentWeapon == -1660422300 then weapon = "CLASS 4: Combat MG" elseif CurrentWeapon == 3686625920 then weapon = "CLASS 4: Combat MG MK2" elseif CurrentWeapon == 1627465347 then weapon = "CLASS 4: Gusenberg" elseif CurrentWeapon == -1121678507 then weapon = "CLASS 2: Mini SMG" elseif CurrentWeapon == -1074790547 then weapon = "CLASS 3: Assaultrifle" elseif CurrentWeapon == 961495388 then weapon = "CLASS 3: Assaultrifle MK2" elseif CurrentWeapon == -2084633992 then weapon = "CLASS 3: Carbinerifle" elseif CurrentWeapon == 4208062921 then weapon = "CLASS 3: Carbinerifle MK2" elseif CurrentWeapon == -1357824103 then weapon = "CLASS 3: Advancedrifle" elseif CurrentWeapon == -1063057011 then weapon = "CLASS 3: Specialcarbine" elseif CurrentWeapon == 2132975508 then weapon = "CLASS 3: Bulluprifle" elseif CurrentWeapon == 1649403952 then weapon = "CLASS 3: Compactrifle" elseif CurrentWeapon == 100416529 then weapon = "CLASS 4: Sniperrifle" elseif CurrentWeapon == 205991906 then weapon = "CLASS 4: Heavy Sniper" elseif CurrentWeapon == 177293209 then weapon = "CLASS 4: Heavy Sniper MK2" elseif CurrentWeapon == -952879014 then weapon = "CLASS 4: Marksmanrifle" elseif CurrentWeapon == 487013001 then weapon = "CLASS 2: Pumpshotgun" elseif CurrentWeapon == 2017895192 then weapon = "CLASS 2: Sawnoff Shotgun" elseif CurrentWeapon == -1654528753 then weapon = "CLASS 3: Bullupshotgun" elseif CurrentWeapon == -494615257 then weapon = "CLASS 3: Assaultshotgun" elseif CurrentWeapon == -1466123874 then weapon = "CLASS 3: Musket" elseif CurrentWeapon == 984333226 then weapon = "CLASS 3: Heavyshotgun" elseif CurrentWeapon == -275439685 then weapon = "CLASS 2: Doublebarrel Shotgun" elseif CurrentWeapon == 317205821 then weapon = "CLASS 2: Autoshotgun" elseif CurrentWeapon == -1568386805 then weapon = "CLASS 5: GRENADE LAUNCHER" elseif CurrentWeapon == -1312131151 then weapon = "CLASS 5: RPG" elseif CurrentWeapon == 125959754 then weapon = "CLASS 5: Compactlauncher" else weapon = "UNKNOWN" end
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "shooting", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        gender = gender,
        weapon = weapon,
        speed = speed,
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
        dispatchMessage = "Shots Fired",
        job = {"police"}
    })
end exports('Shooting', Shooting)

local function SpeedingVehicle(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Speeding Vehicle",
        job = {"police"}
    })
end exports('SpeedingVehicle', SpeedingVehicle)

local function Fight()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Fight In Progress",
        job = {"police"}
    })
end exports('Fight', Fight)

local function InjuriedPerson()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Civilian Down", -- message
        job = {"ambulance"} -- jobs that will get the alerts
    })
end exports('InjuriedPerson', InjuriedPerson)


local function StoreRobbery(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Store Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('StoreRobbery', StoreRobbery)

local function FleecaBankRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "bankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
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
        dispatchMessage = "Fleeca Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "paletobankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
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
        dispatchMessage = "Paleto Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PaletoBankRobbery', PaletoBankRobbery)

local function PacificBankRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "pacificbankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
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
        dispatchMessage = "Pacific Bank Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PacificBankRobbery', PacificBankRobbery)

local function PrisonBreak()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Prison Break In Progress", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('PrisonBreak', PrisonBreak)

local function VangelicoRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vangelicorobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
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
        dispatchMessage = "Vangelico Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('VangelicoRobbery', VangelicoRobbery)

local function HouseRobbery()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "House Robbery", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('HouseRobbery', HouseRobbery)

local function DrugSale()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "suspicioushandoff", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
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
        dispatchMessage = "Suspicious Handoff", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('DrugSale', DrugSale)

local function CarJacking(vehicle)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "Car Jacking",
        job = {"police"}
    })
end exports('CarJacking', CarJacking)

RegisterNetEvent("qb-dispatch:client:officerdown", function()
    local plyData = QBCore.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local callsign = QBCore.Functions.GetPlayerData().metadata["callsign"]
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "officerdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        callsign = callsign,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Officer Down", -- message
        job = {"police", "ambulance"} -- jobs that will get the alerts
    })
end) 

RegisterNetEvent("qb-dispatch:client:emsdown", function()
    local plyData = QBCore.Functions.GetPlayerData()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local callsign = QBCore.Functions.GetPlayerData().metadata["callsign"]
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "emsdown", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-99",
        firstStreet = locationInfo,
        name = plyData.charinfo.firstname:sub(1,1):upper()..plyData.charinfo.firstname:sub(2).. " ".. plyData.charinfo.lastname:sub(1,1):upper()..plyData.charinfo.lastname:sub(2),
        model = nil,
        plate = nil,
        callsign = callsign,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "EMS Down", -- message
        job = {"police", "ambulance"} -- jobs that will get the alerts
    })
end) 

local function Explosion()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
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
        dispatchMessage = "EXPLOSION REPORTED", -- message
        job = {"police"} -- jobs that will get the alerts
    })
end exports('Explosion', Explosion)

RegisterCommand('testdispatch',function()
    TriggerEvent('')
end)
