local vehicleWhitelist = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [17] = true, [19] = true, [20] = true }

-- CreateThread(function()
--
--     local sleep = 100
--     while true do
--         playerPed = PlayerPedId()
--         if (not isPlayerWhitelisted or Config.Debug) then
--             for k, v in pairs(Config.Timer) do
--                 if v > 0 then Config.Timer[k] = v - 1 end
--             end
--             if GetVehiclePedIsUsing(playerPed) ~= 0 then
--                 local vehicle = GetVehiclePedIsUsing(playerPed, true)
--                 if vehicleWhitelist[GetVehicleClass(vehicle)] then
--                     local driver = GetPedInVehicleSeat(vehicle, -1)
--                     if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
--                         sleep = 10
--                         if IsPedShooting(playerPed) then
--                             local vehicle = vehicleData(vehicle)
--                             exports['ps-dispatch']:VehicleShooting(vehicle)
--                             Config.Timer['Shooting'] = Config.Shooting.Success
--                         else
--                             Config.Timer['Shooting'] = Config.Shooting.Fail
--                         end
--                     end
--                     --     sleep = 100
--                     --     if (GetEntitySpeed(vehicle) * 3.6) >= (120 + (math.random(30, 60))) then
--                     --         Wait(400)
--                     --         if IsPedInAnyVehicle(playerPed, true) and ((GetEntitySpeed(vehicle) * 3.6) >= 90) then
--                     --             local vehicle = vehicleData(vehicle)
--                     --             exports['ps-dispatch']:SpeedingVehicle(vehicle)
--                     --             Config.Timer['Speeding'] = Config.Speeding.Success
--                     --         end
--                     --     else
--                     --         Config.Timer['Speeding'] = Config.Speeding.Fail
--                     --     end
--                     -- else
--                     --     sleep = 100
--                     -- end
--                 end
--             else
--                 -- if Config.Timer['Shooting'] == 0 and not IsPedCurrentWeaponSilenced(playerPed) and IsPedArmed(playerPed, 4) then
--                 --     sleep = 50
--                 --     if IsPedShooting(playerPed) and not BlacklistedWeapon(playerPed) then
--                 --         exports['ps-dispatch']:Shooting()
--                 --         Config.Timer['Shooting'] = Config.Shooting.Success
--                 --     else
--                 --         Config.Timer['Shooting'] = Config.Shooting.Fail
--                 --     end
--                 -- elseif Config.Timer['Melee'] == 0 and IsPedInMeleeCombat(playerPed) and HasPedBeenDamagedByWeapon(GetMeleeTargetForPed(playerPed), 0, 1) then
--                 --     sleep = 50
--                 --     exports['ps-dispatch']:Fight()
--                 --     Config.Timer['Melee'] = Config.Melee.Success
--                 -- else sleep = 100 end
--             end
--         end
--         Wait(sleep)
--     end
-- end)

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
                if not Config.VehicleShooting and not BlacklistedWeapon(playerPed) and not IsPedCurrentWeaponSilenced(Player) and IsPedArmed(Player, 4) then
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
---Need to check this event, this fire every time a driver is doing crazy stuff like jumping on street, going too fast doesn't trigger
---@param a table
---@param b number
---@param c nil
AddEventHandler("CEventShockingMadDriver", function(a, b, c)
    local Player = b
    local Vehicle = GetVehiclePedIsIn(Player, true)
    if not Config.Reckless then
        if ((GetEntitySpeed(Vehicle) * 3.6) >= 90) then
            print(((GetEntitySpeed(Vehicle) * 3.6) >= 90))
            local vehicle = vehicleData(Vehicle)
            exports['ps-dispatch']:SpeedingVehicle(vehicle)
            Config.Reckless = true
            Citizen.SetTimeout(10000, function()
                Config.Reckless = false
            end)
        end
    end
end)
