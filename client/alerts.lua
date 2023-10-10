local function VehicleTheft()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('vehicletheft'),
        codeName = 'vehicletheft',
        code = '10-35',
        icon = 'fas fa-car-burst',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VehicleTheft', VehicleTheft)

local function Shooting()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('shooting'),
        codeName = 'shooting',
        code = '10-11',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        gender = GetPlayerGender(),
        weapon = GetWeaponName(),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Shooting', Shooting)

local function Hunting()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('hunting'),
        codeName = 'hunting',
        code = '10-13',
        icon = 'fas fa-gun',
        priority = 2,
        weapon = GetWeaponName(),
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Hunting', Hunting)

local function VehicleShooting()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('vehicleshots'),
        codeName = 'vehicleshots',
        code = '10-60',
        icon = 'fas fa-gun',
        priority = 2,
        coords = coords,
        weapon = GetWeaponName(),
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VehicleShooting', VehicleShooting)

local function SpeedingVehicle()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('speeding'),
        codeName = 'speeding',
        code = '10-11',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SpeedingVehicle', SpeedingVehicle)

local function Fight()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('melee'),
        codeName = 'fight',
        code = '10-10',
        icon = 'fas fa-hand-fist',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Fight', Fight)

local function PrisonBreak()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('prisonbreak'),
        codeName = 'prisonbreak',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PrisonBreak', PrisonBreak)

local function StoreRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('storerobbery'),
        codeName = 'storerobbery',
        code = '10-90',
        icon = 'fas fa-store',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('StoreRobbery', StoreRobbery)

local function FleecaBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('fleecabank'),
        codeName = 'bankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('FleecaBankRobbery', FleecaBankRobbery)

local function PaletoBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('paletobank'),
        codeName = 'paletobankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PaletoBankRobbery', PaletoBankRobbery)

local function PacificBankRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('pacificbank'),
        codeName = 'pacificbankrobbery',
        code = '10-90',
        icon = 'fas fa-vault',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('PacificBankRobbery', PacificBankRobbery)

local function VangelicoRobbery(camId)
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('vangelico'),
        codeName = 'vangelicorobbery',
        code = '10-90',
        icon = 'fas fa-gem',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        camId = camId,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('VangelicoRobbery', VangelicoRobbery)

local function HouseRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('houserobbery'),
        codeName = 'houserobbery',
        code = '10-90',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('HouseRobbery', HouseRobbery)

local function YachtHeist()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('yachtheist'),
        codeName = 'yachtheist',
        code = '10-65',
        icon = 'fas fa-house',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('YachtHeist', YachtHeist)

local function DrugSale()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('drugsell'),
        codeName = 'suspicioushandoff',
        code = '10-13',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DrugSale', DrugSale)

local function SuspiciousActivity()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('susactivity'),
        codeName = 'susactivity',
        code = '10-66',
        icon = 'fas fa-tablets',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SuspiciousActivity', SuspiciousActivity)

local function CarJacking(vehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(vehicle)

    local dispatchData = {
        message = locale('carjacking'),
        codeName = 'carjack',
        code = '10-35',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CarJacking', CarJacking)

local function InjuriedPerson()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('persondown'),
        codeName = 'civdown',
        code = '10-69',
        icon = 'fas fa-face-dizzy',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'ems' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('InjuriedPerson', InjuriedPerson)

local function DeceasedPerson()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('civbled'),
        codeName = 'civdead',
        code = '10-69',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'ems' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DeceasedPerson', DeceasedPerson)

local function OfficerDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('officerdown'),
        codeName = 'officerdown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('OfficerDown', OfficerDown)

RegisterNetEvent("ps-dispatch:client:officerdown", function() OfficerDown() end)

local function OfficerInDistress()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('officerdistress'),
        codeName = 'officerdistress',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('OfficerInDistress', OfficerInDistress)

local function EmsDown()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('emsdown'),
        codeName = 'emsdown',
        code = '10-99',
        icon = 'fas fa-skull',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
        callsign = PlayerData.metadata["callsign"],
        jobs = { 'ems', 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('EmsDown', EmsDown)

RegisterNetEvent("ps-dispatch:client:emsdown", function() EmsDown() end)

local function Explosion()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('explosion'),
        codeName = 'explosion',
        code = '10-80',
        icon = 'fas fa-fire',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('Explosion', Explosion)

local function CustomAlert(data)
    local coords = data.coords or vec3(0.0, 0.0, 0.0)
    if data.job then job = data.job end
    local gender = GetPlayerGender()
    if not data.gender then gender = nil end


    local dispatchData = {
        message = data.message or "",
        codeName = data.dispatchCode or "NONE",
        code = data.code or '10-80',
        icon = 'fas fa-fire',
        priority = data.priority or 2,
        coords = coords,
        gender = gender,
        street = GetStreetAndZone(coords),
        camId = data.camId or nil,
        color = data.firstColor or nil,
        callsign = data.callsign or nil,
        name = data.name or nil,
        vehicle = data.model or nil,
        plate = data.plate or nil,
        doorCount = data.doorCount or nil,
        automaticGunfire = data.automaticGunfire or false,
        alert = {
            displayCode = data.dispatchCode or "NONE",
            description = data.description or "",
            radius = data.radius or 0,
            recipientList = job,
            sprite = data.sprite or 1,
            color = data.color or 1,
            scale = data.scale or 0.5,
            length = data.length or 2,
            sound = data.sound or "Lose_1st",
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset",
            offset = data.offset or "false",
            flash = data.flash or "false"
        },
        jobs = { 'leo' },
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CustomAlert', CustomAlert)

local function PhoneCall(message, anonymous, job)
    local coords = GetEntityCoords(cache.ped)

    if IsCallAllowed(message) then
        PhoneAnimation()

        local dispatchData = {
            message = anonymous and locale('anon_call') or locale('call'),
            codeName = '911call',
            code = '911',
            icon = 'fas fa-phone',
            priority = 2,
            coords = coords,
            name = anonymous and locale('anon') or (PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname),
            number = anonymous and locale('hidden_number') or PlayerData.charinfo.phone,
            information = message,
            street = GetStreetAndZone(coords),
            jobs = job
        }

        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    end
end

--- @param data string -- Message
--- @param type string -- What type of emergency
--- @param anonymous boolean -- Is the call anonymous
RegisterNetEvent('ps-dispatch:client:sendEmergencyMsg', function(data, type, anonymous)
    local jobs = { ['911'] = { 'leo' }, ['311'] = { 'ems' } }

    PhoneCall(data, anonymous, jobs[type])
end)


local function ArtGalleryRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('artgalleryrobbery'),
        codeName = 'artgalleryrobbery',
        code = '10-90',
        icon = 'fas fa-brush',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('ArtGalleryRobbery', ArtGalleryRobbery)

local function HumaneRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('humanelabsrobbery'),
        codeName = 'humanelabsrobbery',
        code = '10-90',
        icon = 'fas fa-flask-vial',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)

end
exports('HumaneRobbery', HumaneRobbery)

local function TrainRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('trainrobbery'),
        codeName = 'trainrobbery',
        code = '10-90',
        icon = 'fas fa-train',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)

end
exports('TrainRobbery', TrainRobbery)

local function VanRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('vanrobbery'),
        codeName = 'vanrobbery',
        code = '10-90',
        icon = 'fas fa-van-shuttle',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)

end
exports('VanRobbery', VanRobbery)

local function UndergroundRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('undergroundrobbery'),
        codeName = 'undergroundrobbery',
        code = '10-90',
        icon = 'fas fa-person-rays',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }
    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('UndergroundRobbery', UndergroundRobbery)

local function DrugBoatRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('drugboatrobbery'),
        codeName = 'drugboatrobbery',
        code = '10-65',
        icon = 'fas fa-ship',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('DrugBoatRobbery', DrugBoatRobbery)

local function UnionRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('unionrobbery'),
        codeName = 'unionrobbery',
        code = '10-90',
        icon = 'fas fa-truck-field',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('UnionRobbery', UnionRobbery)

local function CarBoosting(vehicle)
    local coords = GetEntityCoords(cache.ped)
    local vehicle = GetVehicleData(cache.vehicle)

    local dispatchData = {
        message = locale('carboosting'),
        codeName = 'carboosting',
        code = '10-50',
        icon = 'fas fa-car',
        priority = 2,
        coords = coords,
        street = GetStreetAndZone(coords),
        heading = GetPlayerHeading(),
        vehicle = vehicle.name,
        plate = vehicle.plate,
        color = vehicle.color,
        class = vehicle.class,
        doors = vehicle.doors,
        jobs = { 'leo' }
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('CarBoosting', CarBoosting)

local function SignRobbery()
    local coords = GetEntityCoords(cache.ped)

    local dispatchData = {
        message = locale('signrobbery'),
        codeName = 'signrobbery',
        code = '10-10',
        icon = 'fab fa-artstation',
        priority = 2,
        coords = coords,
        gender = GetPlayerGender(),
        street = GetStreetAndZone(coords),
        jobs = { 'leo'}
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
exports('SignRobbery', SignRobbery)
