local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}

local function isPedAWitness(witnesses, ped)
    for k, v in pairs(witnesses) do
        if v == ped then
            return true
        end
    end
    return false
end

---@param witnesses table | Array of peds that witnessed the shots
---@param ped number | The ped that shot the gun
---@param coords table | The coords of the ped that shot the gun
AddEventHandler("CEventShockingGunshotFired", function(witnesses, ped, coords)
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Shooting'] ~= 0 then return end
    -- The ped that shot the gun must be the player.
    if PlayerPedId() ~= ped then return end
    -- This event can be triggered multiple times for a single gunshot, so we only want to run the code once.
    -- If there are no witnesses, then the player is the shooter.
    -- Else if there are witnesses, then the player will also be in that table.
    -- If one of these conditions are met, then we can continue.
    if witnesses and not isPedAWitness(witnesses, ped) then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    -- If the weapon is silenced or blacklisted, then we don't want to trigger the event.
    if IsPedCurrentWeaponSilenced(ped) or BlacklistedWeapon(ped) then return end
    local vehicle = GetVehiclePedIsUsing(ped, true)
    if vehicle ~= 0 then
        if vehicleWhitelist[GetVehicleClass(vehicle)] then
            vehicle = vehicleData(vehicle)
            exports['ps-dispatch']:VehicleShooting(vehicle, ped, coords)
            Config.Timer['Shooting'] = Config.Shooting.Success
        end
    else
        exports['ps-dispatch']:Shooting(ped, coords)
        Config.Timer['Shooting'] = Config.Shooting.Success
    end
end)

---@param witnesses table | Array of entity handles who witnessed the event
---@param ped number | Entity handle of the ped who triggered the event
---@param coords table | The coords of the ped who triggered the event
AddEventHandler('CEventShockingCarCrash', function(witnesses, ped, coords)
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Speeding'] ~= 0 then return end
    -- The ped that triggered the event must be the player.
    if PlayerPedId() ~= ped then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    local vehicle = GetVehiclePedIsUsing(ped, true)
    if vehicleWhitelist[GetVehicleClass(vehicle)] then
        local driver = GetPedInVehicleSeat(vehicle, -1)
        if ped == driver then
            if (GetEntitySpeed(vehicle) * 3.6) >= (120 + (math.random(30,60))) then
                Wait(400)
                if ((GetEntitySpeed(vehicle) * 3.6) >= 90) then
                    vehicle = vehicleData(vehicle)
                    exports['ps-dispatch']:SpeedingVehicle(vehicle, ped, coords)
                    Config.Timer['Speeding'] = Config.Speeding.Success
                end
            else
                Config.Timer['Speeding'] = Config.Speeding.Fail
            end
        end
    end
end)

---@param witnesses table | Array of peds that witnessed the event
---@param attacker number | The ped that used the melee weapon
---@param coords table | The coords of the attacker
AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, attacker, coords)
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Melee'] ~= 0 then return end
    -- The ped that melee attacked must be the player.
    if PlayerPedId() ~= attacker then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    -- If the only witnesses is the victim, then we don't want to trigger the event.
    if #witnesses == 1 and witnesses[1] ~= GetMeleeTargetForPed(attacker) then return end
    exports['ps-dispatch']:Fight(attacker, coords)
    Config.Timer['Melee'] = Config.Melee.Success
end)

---@param witnesses table | Array of peds that witnessed the event
---@param jacker number | The ped that jacked the vehicle
---@param coords table | The coords of the attacker
AddEventHandler('CEventShockingSeenCarStolen', function(witnesses, jacker, coords)
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Autotheft'] ~= 0 then return end
    -- The ped that melee attacked must be the player.
    if PlayerPedId() ~= jacker then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    -- If the only witnesses is the victim, then we don't want to trigger the event.
   --  if #witnesses == 1 and witnesses[1] ~= GetMeleeTargetForPed(ped) then return end
    local vehicle = GetVehiclePedIsUsing(jacker, true)
    if vehicleWhitelist[GetVehicleClass(vehicle)] then
        if GetSelectedPedWeapon(jacker) ~= `WEAPON_UNARMED` then
            exports['ps-dispatch']:CarJacking(vehicle, jacker, coords)
            Config.Timer['Autotheft'] = Config.Autotheft.Success
        else
            exports['ps-dispatch']:VehicleTheft(vehicle, jacker, coords)
            Config.Timer['Autotheft'] = Config.Autotheft.Success
        end
    end
end)