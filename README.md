# qb-dispatch

WIP for cleaner and more easier to setup Dispatch compatible with QB-mdt


# Steps to Create New Alert

1. Create a client event that will be triggered from whatever script you want

```lua
RegisterNetEvent("qb-dispatch:client:storerobbery", function()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    local heading = getCardinalDirectionFromHeading()
    
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "storerobbery", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-90",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        heading = heading,
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
```

2. Add Dispatch Code in sv_dispatchcodes.lua for the particular robbery to display the blip

`["storerobbery"] is the dispatchcodename you passed with the TriggerServerEvent in step 1`
```lua
    ["storerobbery"] =  {displayCode = '10-13', description = "Armed Player", radius = 0, recipientList = {'police'}, blipSprite = 648, blipColour = 84, blipScale = 1.5, blipLength = 2 },
```

Information about each parameter is in the file.


# Work to be done

1. 911, 311 calls
2. Locales for alerts
3. Create basic alerts for qbcore (store, bank, house)
4. Edit the blips sprite and color in sv_dispatchcodes.lua
5. Add ability to disable notifications
6. Add onduty check for alerts