local vehicleWhitelist = {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true,[12]=true,[17]=true,[19]=true,[20]=true}

local SpeedingEvents = {
    'CEventShockingCarChase',
    'CEventShockingDrivingOnPavement',
    'CEventShockingBicycleOnPavement',
    -- 'CEventShockingEngineRevved',
    -- 'CEventShockingMadDriver',
    'CEventShockingMadDriverBicycle',
    'CEventShockingMadDriverExtreme',
    'CEventShockingInDangerousVehicle',
    -- 'CEventShockingSeenNiceCar'
}

---@param witnesses table | Array of peds that witnessed the event
---@param ped number | Ped ID to check
---@return boolean | Returns true if the ped is in the witnesses table
local function isPedAWitness(witnesses, ped)
    for k, v in pairs(witnesses) do
        if v == ped then
            return true
        end
    end
    return false
end

---------------------------------------------------------------------------------------

---@param witnesses table | Array of Ped IDs that witnessed the shooting
---@param ped number | The Ped ID of the shooter
---@param coords table | The Coords of the shooter
AddEventHandler('CEventShockingGunshotFired', function(witnesses, ped, coords)
    -- If AutoAlerts are disabled, don't trigger
    if not Config.Enable['Shooting'] then return end
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
    -- If the weapon is silenced then we don't want to trigger the event.
    if IsPedCurrentWeaponSilenced(ped) then return end 
    -- If the weapon is blacklisted then we set the timer to the fail time and return.
    if BlacklistedWeapon(ped) then Config.Timer['Shooting'] = Config.Shooting.Fail return end
    -- Check if the Player is inside a No Dispatch Zone , if so dont make a alert
    if inNoDispatchZone then return end
    -- Check if the Player is in a Hunting Zone and Give that Alert Instead
    if inHuntingZone then exports['ps-dispatch']:Hunting(); Config.Timer['Shooting'] = Config.Shooting.Success return end
    local vehicle = GetVehiclePedIsUsing(ped, true)
    if vehicle ~= 0 then
        -- If the vehicle isn't whitelisted, don't trigger the event
        if not vehicleWhitelist[GetVehicleClass(vehicle)] then Config.Timer['Shooting'] = Config.Shooting.Fail return end
        vehicle = vehicleData(vehicle)
        exports['ps-dispatch']:VehicleShooting(vehicle, ped, coords)
        Config.Timer['Shooting'] = Config.Shooting.Success
    else
        exports['ps-dispatch']:Shooting(ped, coords)
        Config.Timer['Shooting'] = Config.Shooting.Success
    end
end)

---@param witnesses table | Array of Ped IDs that witnessed the event
---@param ped number | The Ped ID of the ped who triggered the event
---@param coords table | The Coords of the ped who triggered the event
for i = 1, #SpeedingEvents do
    local event = SpeedingEvents[i]
    AddEventHandler(event, function(witnesses, ped, coords)
        -- If AutoAlerts are disabled, don't trigger
        if not Config.Enable['Speeding'] then return end
        local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
        -- Use the timer to prevent the event from being triggered multiple times.
        if Config.Timer['Speeding'] ~= 0 then return end
        -- The ped that triggered the event must be the player.
        if PlayerPedId() ~= ped then return end
        -- If the player is a whitelisted job, then we don't want to trigger the event.
        -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
        if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
        -- Check if this event or any other have been triggered in the last 5 seconds.
        -- If so, then we don't want to trigger the event.
        local vehicle = GetVehiclePedIsUsing(ped, true)
        -- If the vehicle isn't whitelisted, don't trigger the event
        if not vehicleWhitelist[GetVehicleClass(vehicle)] then return end 
        local driver = GetPedInVehicleSeat(vehicle, -1)
        -- If the ped isn't the driver, we don't wanna trigger the event
        if ped ~= driver then return end
        if (GetEntitySpeed(vehicle) * 3.6) >= (120 + RandomNum(0, 20)) then
            Wait(400)
            if ((GetEntitySpeed(vehicle) * 3.6) >= 90) then
                vehicle = vehicleData(vehicle)
                exports['ps-dispatch']:SpeedingVehicle(vehicle, ped, coords)
                Config.Timer['Speeding'] = Config.Speeding.Success
            end
        else
            Config.Timer['Speeding'] = Config.Speeding.Fail
        end
    end)
end

---@param witnesses table | Array of Ped IDs that witnessed the event
---@param attacker number | The Ped ID of the attacker
---@param coords table | The Coords of the attacker
AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, attacker, coords)
    -- If AutoAlerts are disabled, don't trigger
    if not Config.Enable['Melee'] then return end
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Melee'] ~= 0 then return end
    -- The ped that melee attacked must be the player.
    if PlayerPedId() ~= attacker then return end
    -- This event can be triggered multiple times for a single melee, so we only want to run the code once.
    -- If there are witnesses, then the player will also be in that table.
    if witnesses and not isPedAWitness(witnesses, attacker) then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    -- If the only witness is the player, then we set the timer to the fail time and return.
    if #witnesses == 0 or #witnesses == 1 and witnesses[1] == attacker then Config.Timer['Melee'] = Config.Melee.Fail return end
    exports['ps-dispatch']:Fight(attacker, coords)
    Config.Timer['Melee'] = Config.Melee.Success
end)

---@param witnesses table | Array of Ped IDs that witnessed the event
---@param jacker number | The Ped ID of the jacker
AddEventHandler('CEventPedJackingMyVehicle', function(witnesses, jacker)
    -- If AutoAlerts are disabled, don't trigger
    if not Config.Enable['Autotheft'] then return end
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
    -- If the vehicle isn't whitelisted, don't trigger the event
    if not vehicleWhitelist[GetVehicleClass(vehicle)] then return end 
    exports['ps-dispatch']:CarJacking(vehicle, jacker)
    Config.Timer['Autotheft'] = Config.Autotheft.Success
end)

---@param witnesses table | Array of Ped IDs that witnessed the event
---@param thief number | The Ped ID of the thief
---@param coords table | The Coords of the thief
AddEventHandler('CEventShockingCarAlarm', function(witnesses, thief, coords)
    -- If AutoAlerts are disabled, don't trigger
    if not Config.Enable['Autotheft'] then return end
    local coords = vector3(coords[1][1], coords[1][2], coords[1][3])
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['Autotheft'] ~= 0 then return end
    -- The ped that melee attacked must be the player.
    if PlayerPedId() ~= thief then return end
    -- If the player is a whitelisted job, then we don't want to trigger the event.
    -- However, if the player is not whitelisted or Debug mode is true, then we want to trigger the event.
    if Config.AuthorizedJobs.LEO.Check() and not Config.Debug then return end
    -- If the only witnesses is the victim, then we don't want to trigger the event.
    --  if #witnesses == 1 and witnesses[1] ~= GetMeleeTargetForPed(ped) then return end
    local vehicle = GetVehiclePedIsUsing(thief, true)
    -- If the vehicle isn't whitelisted, don't trigger the event
    if not vehicleWhitelist[GetVehicleClass(vehicle)] then return end 
    exports['ps-dispatch']:VehicleTheft(vehicle, thief, coords)
    Config.Timer['Autotheft'] = Config.Autotheft.Success
end)

---@param name string | Name of Network Event Triggered
---@param args table | Array of arguments passed from Event Triggered
AddEventHandler('gameEventTriggered', function(name, args)
    -- If AutoAlerts are disabled, don't trigger
    if not Config.Enable['PlayerDowned'] then return end
    -- Use the timer to prevent the event from being triggered multiple times.
    if Config.Timer['PlayerDowned'] ~= 0 then return end
    -- If the Event isn't the damage event, we don't want to trigger the event
    if name ~= 'CEventNetworkEntityDamage' then return end
    local victim = args[1]
    local attacker = args[2]
    local isDead = args[6] == 1
    local weapon = args[7]
    local isMelee = args[12]
    local flags = args[13]
    -- If the victim isn't the Player, we don't want to trigger the event
    if not victim or victim ~= PlayerPedId() then return end
    -- If the victim isn't dead, don't trigger the event as well
    if not isDead then Config.Timer['PlayerDowned'] = Config.PlayerDowned.Fail return end
    -- Check if the player is and EMS, trigger the correct down alerts
    if not Config.AuthorizedJobs.FirstResponder.Check() then exports['ps-dispatch']:InjuriedPerson() end
    if Config.AuthorizedJobs.LEO.Check() then exports['ps-dispatch']:OfficerDown() end
    if Config.AuthorizedJobs.EMS.Check() then exports['ps-dispatch']:EmsDown() end
    Config.Timer['PlayerDowned'] = Config.PlayerDowned.Success
end)
