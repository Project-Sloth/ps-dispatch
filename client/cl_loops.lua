local vehicleWhitelist = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true,
    [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [17] = true, [19] = true, [20] = true }

local check = false
---This event will run only when the player enter a vehicle and will stop inmediate after
---@param ad any
AddEventHandler("CEventShockingSeenCarStolen", function(ad)
    check = true
    local playerPed = PlayerPedId()
    CreateThread(function()
        while check do
            Wait(200)
            if IsPedInAnyVehicle(playerPed, true) then
                local Vehicle = GetVehiclePedIsIn(playerPed, true)
                if not Config.Reckless then
                    if ((GetEntitySpeed(Vehicle) * 3.6) >= 90) then
                        local vehicle = vehicleData(Vehicle)
                        exports['ps-dispatch']:SpeedingVehicle(vehicle)
                        Config.Reckless = true
                        Citizen.SetTimeout(10000, function()
                            Config.Reckless = false
                        end)
                    end
                end
            else
                check = false
            end
        end
    end)
end)



---Event fired every time a player shoot, b arg is the player Ped
---@param _ table
---@param b number
---@param c number
AddEventHandler("CEventGunShot", function(_, b, c)
    local Player = b
    if tonumber(Player) == PlayerPedId() then
        if IsPedInAnyVehicle(Player) then
            local Vehicle = GetVehiclePedIsIn(Player, true)
            if vehicleWhitelist[GetVehicleClass(Vehicle)] then
                if not Config.VehicleShooting and not BlacklistedWeapon(playerPed) and
                    not IsPedCurrentWeaponSilenced(Player) and IsPedArmed(Player, 4) then
                    local vehicle = vehicleData(Vehicle)
                    exports['ps-dispatch']:VehicleShooting(vehicle)
                    Config.VehicleShooting = true
                    Citizen.SetTimeout(10000, function()
                        Config.VehicleShooting = false
                    end)
                end
            end
        else
            if not Config.Shootingevent then
                exports['ps-dispatch']:Shooting()
                Config.Shootingevent = true
                Citizen.SetTimeout(10000, function()
                    Config.Shootingevent = false
                end)
            end
        end
    end
end)

---General event that get triggered every time an entity recive damage, b arg is the player Ped, arg _ is the target Ped
---@param _ table
---@param b number
---@param c nil
AddEventHandler("CEventDamage", function(_, b, c)
    local Player = b
    if Player == PlayerPedId() then
        if IsPedInMeleeCombat(Player) then
            if not Config.MeleeEvent then
                exports['ps-dispatch']:Fight()
                Config.MeleeEvent = true
                Citizen.SetTimeout(10000, function()
                    Config.MeleeEvent = false
                end)
            end
        end
    end
end)

