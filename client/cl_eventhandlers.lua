local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}

local function isPlayerAWitness(witnesses)
    for k, v in pairs(witnesses) do
        if v == PlayerPedId() then
            return true
        end
    end
    return false
end

---@param witnesses table  array of peds that witnessed the shots
---@param ped number  the ped that shot the gun
AddEventHandler("CEventGunShot", function(witnesses, ped)
    -- The ped that shot the gun must be the player.
    if PlayerPedId() ~= ped then return end
    -- This event can be triggered multiple times for a single gunshot, so we only want to run the code once.
    -- If there are no witnesses, then the player is the shooter.
    -- Else if there are witnesses, then the player will also be in that table.
    -- If one of these conditions are met, then we can continue.
    if witnesses and not isPlayerAWitness(witnesses) then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if IsPoliceJob(PlayerJob.name) and not Config.Debug then return end
    local vehicle = GetVehiclePedIsUsing(ped, true)
    if vehicle ~= 0 then
        if vehicleWhitelist[GetVehicleClass(vehicle)] then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if Config.Timer['Shooting'] == 0 and not BlacklistedWeapon(ped) and not IsPedCurrentWeaponSilenced(ped) and IsPedArmed(ped, 4) then
                if IsPedShooting(ped) then
                    local vehicle = vehicleData(vehicle)
                    exports['ps-dispatch']:VehicleShooting(vehicle)
                    Config.Timer['Shooting'] = Config.Shooting.Success
                else
                    Config.Timer['Shooting'] = Config.Shooting.Fail
                end
            end
        end
    else
        if Config.Timer['Shooting'] == 0  and not IsPedCurrentWeaponSilenced(ped) and IsPedArmed(ped, 4) then
            if IsPedShooting(ped) and not BlacklistedWeapon(ped) then
                exports['ps-dispatch']:Shooting()
                Config.Timer['Shooting'] = Config.Shooting.Success
            else
                Config.Timer['Shooting'] = Config.Shooting.Fail
            end
        end
    end
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param x number | X coord of ped
---@param y number | Y coord of ped
---@param z number | Z coord of ped
AddEventHandler('CEventShockingMadDriver', function(witnesses, ped, x, y, z)
    -- The ped that triggered the event must be the player.
    if PlayerPedId() ~= ped then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if IsPoliceJob(PlayerJob.name) and not Config.Debug then return end
    local vehicle = GetVehiclePedIsUsing(ped, true)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    if vehicleWhitelist[GetVehicleClass(vehicle)] then
        if Config.Timer['Speeding'] == 0 and ped == driver then
            if (GetEntitySpeed(vehicle) * 3.6) >= (120 + (math.random(30,60))) then
                Wait(400)
                if IsPedInAnyVehicle(ped, true) and ((GetEntitySpeed(vehicle) * 3.6) >= 90) then
                    vehicle = vehicleData(vehicle)
                    exports['ps-dispatch']:SpeedingVehicle(vehicle)
                    Config.Timer['Speeding'] = Config.Speeding.Success
                end
            else
                Config.Timer['Speeding'] = Config.Speeding.Fail
            end
        end
    end
end)

---@param witnesses table | Array of peds that witnessed the event, where witnesses[1] is the victim
---@param attacker number | The ped that attacked the victim
AddEventHandler('CEventMeleeAction', function(witnesses, attacker)
	-- The ped that melee attacked must be the player.
    if PlayerPedId() ~= attacker then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if IsPoliceJob(PlayerJob.name) and not Config.Debug then return end
    if Config.Timer['Melee'] == 0 then
        exports['ps-dispatch']:Fight()
        Config.Timer['Melee'] = Config.Melee.Success
    end
end)