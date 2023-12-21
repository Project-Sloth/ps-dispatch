local timer = {}

---@param name string -- The name of the timer
---@param action function -- The function to execute when the timer is up
---@vararg any -- Arguments to pass to the action function
local function WaitTimer(name, action, ...)
    if not Config.DefaultAlerts[name] then return end

    if not timer[name] then
        timer[name] = true
        action(...)
        Wait(Config.DefaultAlertsDelay * 1000)
        timer[name] = false
    end
end

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

---@param ped number | Ped ID to check
---@return boolean | Returns true if the ped is holding a whitelisted gun
local function BlacklistedWeapon(ped)
	for i = 1, #Config.WeaponWhitelist do
		local weaponHash = joaat(Config.WeaponWhitelist[i])
		if GetSelectedPedWeapon(ped) == weaponHash then
			return true -- Is a whitelisted weapon
		end
	end
	return false -- Is not a whitelisted weapon
end

AddEventHandler('CEventGunShot', function(witnesses, ped)
    if IsPedCurrentWeaponSilenced(cache.ped) then return end
    if inNoDispatchZone then return end
    if BlacklistedWeapon(cache.ped) then return end
        
    WaitTimer('Shooting', function()
        if cache.ped ~= ped then return end

        if PlayerData.job.type == 'leo' then
            if not Config.Debug then
                return
            end
        end

        if inHuntingZone then
            exports['ps-dispatch']:Hunting()
            return
        end

        if witnesses and not isPedAWitness(witnesses, ped) then return end

        if cache.vehicle then
            exports['ps-dispatch']:VehicleShooting()
        else
            exports['ps-dispatch']:Shooting()
        end
    end)
end)

AddEventHandler('CEventShockingSeenMeleeAction', function(witnesses, ped)
    WaitTimer('Melee', function()
        if cache.ped ~= ped then return end
        if witnesses and not isPedAWitness(witnesses, ped) then return end
        if not IsPedInMeleeCombat(ped) then return end

        exports['ps-dispatch']:Fight()
    end)
end)

AddEventHandler('CEventPedJackingMyVehicle', function(_, ped)
    WaitTimer('Autotheft', function()
        if cache.ped ~= ped then return end
        local vehicle = GetVehiclePedIsUsing(ped, true)
        exports['ps-dispatch']:CarJacking(vehicle)
    end)
end)

AddEventHandler('CEventShockingCarAlarm', function(_, ped)
    WaitTimer('Autotheft', function()
        if cache.ped ~= ped then return end
        local vehicle = GetVehiclePedIsUsing(ped, true)
        exports['ps-dispatch']:VehicleTheft(vehicle)
    end)
end)

AddEventHandler('CEventExplosionHeard', function(witnesses, ped)
    if witnesses and not isPedAWitness(witnesses, ped) then return end
    WaitTimer('Explosion', function()
        exports['ps-dispatch']:Explosion()
    end)
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end
    local victim = args[1]
    local isDead = args[6] == 1
    WaitTimer('PlayerDowned', function()
        if not victim or victim ~= cache.ped then return end
        if not isDead then return end

        if PlayerData.job.type == 'leo' then
            exports['ps-dispatch']:OfficerDown()
        elseif PlayerData.job.type == 'ems' then
            exports['ps-dispatch']:EmsDown()
        else
            exports['ps-dispatch']:InjuriedPerson()
        end
    end)
end)

local SpeedingEvents = {
    'CEventShockingCarChase',
    'CEventShockingDrivingOnPavement',
    'CEventShockingBicycleOnPavement',
    'CEventShockingMadDriverBicycle',
    'CEventShockingMadDriverExtreme',
    'CEventShockingEngineRevved',
    'CEventShockingInDangerousVehicle'
}

local SpeedTrigger = 0
for i = 1, #SpeedingEvents do
    local event = SpeedingEvents[i]
    AddEventHandler(event, function(_, ped)
        WaitTimer('Speeding', function()
            local currentTime = GetGameTimer()
            if currentTime - SpeedTrigger < 10000 then
                return
            end
            if cache.ped ~= ped then return end

            if PlayerData.job.type == 'leo' then
                if not Config.Debug then
                    return
                end
            end
            
            if GetEntitySpeed(cache.vehicle) * 3.6 < (80 + math.random(0, 20)) then return end

            if cache.ped ~= GetPedInVehicleSeat(cache.vehicle, -1) then return end

            exports['ps-dispatch']:SpeedingVehicle()
            SpeedTrigger = GetGameTimer()
        end)
    end)
end
