RegisterNetEvent("qb-dispatch:client:vehicleshooting", function(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vehicleshots", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-60",
        firstStreet = locationInfo,
        gender = gender,
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
        dispatchMessage = "Shots Fired from Vehicle",
        job = {"ambulance","police"}
    })
end)

RegisterNetEvent("qb-dispatch:client:speeding", function(vehdata)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        gender = gender,
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
end)

RegisterNetEvent("qb-dispatch:client:shooting", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "shooting", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Shots Fired",
        job = {"police"}
    })
end)

RegisterNetEvent("qb-dispatch:client:fight", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "fight", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-10",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2,
        firstColor = nil,
        heading = heading,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = "Fight In Progress",
        job = {"police"}
    })
end)

RegisterNetEvent("qb-dispatch:client:civdown", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
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
end)


RegisterNetEvent("qb-dispatch:client:storerobbery", function(camId)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "storerobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:fleecabankrobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "bankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:paletobankrobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "paletobankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:pacificbankrobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "pacificbankrobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:prisonbreak", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "prisonbreak", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:vangelicorobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "vangelicorobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:houserobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "houserobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
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
end)

RegisterNetEvent("qb-dispatch:client:drugsale", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
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
end)

RegisterCommand('testdispatch',function()
    TriggerEvent('qb-dispatch:client:unionrobbery')
end)