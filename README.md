# Beta Released

Integrated with https://github.com/Project-Sloth/ps-mdt

For all support questions, ask in our Discord support chat. Do not create issues if you need help. Issues are for bug reporting and new features only.

https://www.discord.gg/projectsloth

# Installation
* Download ZIP
* Drag and drop resource into your server files
* Start resource through server.cfg
* Drag and drop sounds folder into interact-sound\client\html\sounds
* Restart your server.


# Alert Exports
```lua
- exports['ps-disptach']:VehicleShooting(vehicle)

- exports['ps-disptach']:Shooting()

- exports['ps-disptach']:SpeedingVehicle(vehicle)

- exports['ps-disptach']:Fight()

- exports['ps-disptach']:InjuriedPerson()

- exports['ps-disptach']:StoreRobbery(camId)

- exports['ps-disptach']:FleecaBankRobbery()

- exports['ps-disptach']:PaletoBankRobbery()

- exports['ps-disptach']:PacificBankRobbery()

- exports['ps-disptach']:PrisonBreak()

- exports['ps-disptach']:VangelicoRobbery()

- exports['ps-disptach']:HouseRobbery()

- exports['ps-disptach']:PrisonBreak()

- exports['ps-disptach']:DrugSale()

- exports['ps-disptach']:ArtGalleryRobbery()

- exports['ps-disptach']:HumaneRobery()

- exports['ps-disptach']:TrainRobbery()

- exports['ps-disptach']:VanRobbery()

- exports['ps-disptach']:UndergroundRobbery()

- exports['ps-disptach']:DrugBoatRobbery()

- exports['ps-disptach']:UnionRobbery()

- exports['ps-disptach']:YachtHeist()

- exports['ps-disptach']:CarBoosting(vehicle)

- exports['ps-disptach']:CarJacking(vehicle)

- exports['ps-disptach']:VehicleTheft(vehicle)
```

# Steps to Create New Alert

1. Create a client event that will be triggered from whatever script you want

```lua
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
```

2. Add Dispatch Code in sv_dispatchcodes.lua for the particular robbery to display the blip

`["storerobbery"] is the dispatchcodename you passed with the TriggerServerEvent in step 1`
```lua
	["bankrobbery"] =  {displayCode = '10-90', description = "Fleeca Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 2, blipScale = 1.5, blipLength = 2, sound = "robberysound"},
```
Information about each parameter is in the file.

# Alerts with Vehicle Information
1. If you want to display vehicle information with a particular alert, you need to pass the vehicle along with the exports like this
```lua 
exports["qb-dipatch"]:TestVehicleAlert(vehicle)
```

and its function in ps-disptach would look like this

```lua
local function TestVehicleAlert(vehicle)
    local vehdata = vehicleData(vehicle)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local heading = getCardinalDirectionFromHeading()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "speeding", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-11",
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
        dispatchMessage = "Speeding Vehicle",
        job = {"police"}
    })
end 

exports('SpeedingVehicle', SpeedingVehicle)
```

Rest steps will be similar as mentioned above in Steps to create alerts.

# Work to be done

* Hunting Zones
* Locales for alerts
