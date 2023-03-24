PlayerData = {}
PlayerJob = {}
inHuntingZone = false
inNoDispatchZone = false
QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
local radius2 = {}
Waypoint = nil

-- Debugging and testing dispatch alerts - Uncomment to use. 
--RegisterCommand('testdispatch',function ()
--    TriggerEvent('')
--end)

-- core related

AddEventHandler('onResourceStart', function(resource)
	if GetCurrentResourceName() ~= resource then return end
	PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = QBCore.Functions.GetPlayerData().job
	
	-- Create Hunting Zone Blips --
	if not Config.Locations['hunting'][1] then return end
	for _, hunting in pairs(Config.Locations["hunting"]) do
		local blip = AddBlipForCoord(hunting.coords.x, hunting.coords.y, hunting.coords.z)
		local huntingradius = AddBlipForRadius(hunting.coords.x, hunting.coords.y, hunting.coords.z, hunting.radius)
		SetBlipSprite(blip, 442)
		SetBlipAsShortRange(blip, true)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 0)
		SetBlipColour(huntingradius, 0)
		SetBlipAlpha(huntingradius, 40)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(hunting.label)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	PlayerData = {}
	currentCallSign = ""
	if not Config.Locations['hunting'][1] then return end
	local blip = GetFirstBlipInfoId(442)
  repeat RemoveBlip(blip); blip = GetNextBlipInfoId(442) until not DoesBlipExist(blip)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
	PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = JobInfo
end)

-- Create Hunting Zone, Code Executes as a Chunk when Scipt is Loaded and Doesn't need to be an Asynchronous Thread --

if Config.Locations['hunting'][1] then
	for _, hunting in pairs(Config.Locations["hunting"]) do
		local huntingzone = CircleZone:Create(vector3(hunting.coords.x, hunting.coords.y, hunting.coords.z), hunting.radius, {
			name = Config.Locations["hunting"].label,
			useZ = true,
			debugPoly = false
		})

		huntingzone:onPlayerInOut(function(isPointInside)
			inHuntingZone = isPointInside
		end)
	end
end

-- Create No Dispatch Zone --

if Config.Locations['NoDispatch'][1] then
	for _, nodispatch in pairs(Config.Locations["NoDispatch"]) do
		local nodispatchzone = BoxZone:Create(vector3(nodispatch.coords.x, nodispatch.coords.y, nodispatch.coords.z), nodispatch.length, nodispatch.width, {
			name = Config.Locations["NoDispatch"].label,
			heading = nodispatch.heading,
			minZ = nodispatch.minZ,
			maxZ = nodispatch.maxZ,
			debugPoly = false
		})

		nodispatchzone:onPlayerInOut(function(isPointInside)
			inNoDispatchZone = isPointInside
		end)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function _U(entry)
	return Locales[Config.Locale][entry] 
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function RandomNum(min, max)
  math.randomseed(GetGameTimer())
  local num = math.random() * (max - min) + min
  if num % 1 >= 0.5 and math.ceil(num) <= max then
    return math.ceil(num)
  end
	return math.floor(num)
end

function getSpeed() return speedlimit end
function getStreet() return currentStreetName end
function getStreetandZone(coords)
	local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	playerStreetsLocation = currentStreetName .. ", " .. zone
	return playerStreetsLocation
end

function refreshPlayerWhitelisted()
	if not PlayerData then return false end
	if not PlayerData.job then return false end
	if Config.Debug then return true end
	if Config.AuthorizedJobs.FirstResponder.Check() then return true end
	return false
end

function BlacklistedWeapon(playerPed)
	for i = 1, #Config.WeaponBlacklist do
		local weaponHash = GetHashKey(Config.WeaponBlacklist[i])
		if GetSelectedPedWeapon(playerPed) == weaponHash then
			return true -- Is a blacklisted weapon
		end
	end
	return false -- Is not a blacklisted weapon
end

function GetAllPeds()
	local getPeds = {}
	local findHandle, foundPed = FindFirstPed()
	local continueFind = (foundPed and true or false)
	local count = 0
	while continueFind do
		local pedCoords = GetEntityCoords(foundPed)
		if GetPedType(foundPed) ~= 28 and not IsEntityDead(foundPed) and not IsPedAPlayer(foundPed) and #(playerCoords - pedCoords) < 80.0 then
			getPeds[#getPeds + 1] = foundPed
			count = count + 1
		end
		continueFind, foundPed = FindNextPed(findHandle)
	end
	EndFindPed(findHandle)
	return count
end

function zoneChance(type, zoneMod, street)
	if Config.DebugChance then return true end
	if not street then street = currentStreetName end
	playerCoords = GetEntityCoords(PlayerPedId())
	local zone, sendit = GetLabelText(GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)), false
	if not nearbyPeds then
		nearbyPeds = GetAllPeds()
	elseif nearbyPeds < 1 then if Config.Debug then print(('^1[%s] Nobody is nearby to send a report^7'):format(type)) end
		return false
	end
	if zoneMod == nil then zoneMod = 1 end
	zoneMod = (math.ceil(zoneMod+0.5))
	local hour = GetClockHours()
	if hour >= 21 or hour <= 4 then
		zoneMod = zoneMod * 1.6
		zoneMod = math.ceil(zoneMod+0.5)
	end
	zoneMod = zoneMod / (nearbyPeds / 3)
	zoneMod = (math.ceil(zoneMod+0.5))
	local sum = RandomNum(1, zoneMod)
	local chance = string.format('%.2f',(1 / zoneMod) * 100)..'%'

	if sum > 1 then
		if Config.Debug then print(('^1[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds)) end
		sendit = false
	else
		if Config.Debug then print(('^2[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds)) end
		sendit = true
	end
    print(('^1[%s] %s (%s) - %s nearby peds^7'):format(type, zone, chance, nearbyPeds))
	return sendit
end

function vehicleData(vehicle)
	local vData = {}
	local vehicleClass = GetVehicleClass(vehicle)
	local vClass = {[0] = _U('compact'), [1] = _U('sedan'), [2] = _U('suv'), [3] = _U('coupe'), [4] = _U('muscle'), [5] = _U('sports_classic'), [6] = _U('sports'), [7] = _U('super'), [8] = _U('motorcycle'), [9] = _U('offroad'), [10] = _U('industrial'), [11] = _U('utility'), [12] = _U('van'), [17] = _U('service'), [19] = _U('military'), [20] = _U('truck')}
	local vehClass = vClass[vehicleClass]
	local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	local vehicleColour1, vehicleColour2 = GetVehicleColours(vehicle)
	if vehicleColour1 then
		if Config.Colours[tostring(vehicleColour2)] and Config.Colours[tostring(vehicleColour1)] then
			vehicleColour = Config.Colours[tostring(vehicleColour2)] .. " on " .. Config.Colours[tostring(vehicleColour1)]
		elseif Config.Colours[tostring(vehicleColour1)] then
			vehicleColour = Config.Colours[tostring(vehicleColour1)]
		elseif Config.Colours[tostring(vehicleColour2)] then
			vehicleColour = Config.Colours[tostring(vehicleColour2)]
		else
			vehicleColour = "Unknown"
		end
	end
	local plate = GetVehicleNumberPlateText(vehicle)
	local doorCount = 0
	if GetEntityBoneIndexByName(vehicle, 'door_pside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_pside_r') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_f') ~= -1 then doorCount = doorCount + 1 end
	if GetEntityBoneIndexByName(vehicle, 'door_dside_r') ~= -1 then doorCount = doorCount + 1 end
	if doorCount == 2 then doorCount = _U('two_door') elseif doorCount == 3 then doorCount = _U('three_door') elseif doorCount == 4 then doorCount = _U('four_door') else doorCount = '' end
	vData.class, vData.name, vData.colour, vData.doors, vData.plate, vData.id = vehClass, vehicleName, vehicleColour, doorCount, plate, NetworkGetNetworkIdFromEntity(vehicle)
	return vData
end

function GetPedGender()
	local gender = "Male"
	if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then gender = "Female" end
	return gender
end

function getCardinalDirectionFromHeading()
	local heading = GetEntityHeading(PlayerPedId())
	if heading >= 315 or heading < 45 then return "North Bound"
	elseif heading >= 45 and heading < 135 then return "West Bound"
	elseif heading >=135 and heading < 225 then return "South Bound"
	elseif heading >= 225 and heading < 315 then return "East Bound" end
end

local function IsValidJob(jobList)
	for i = 1, #jobList do
		if Config.AuthorizedJobs[jobList[i]] and Config.AuthorizedJobs[jobList[i]].Check() or PlayerJob.name == jobList[i] then 
			return true
		end
	end
	return false
end

local function CheckOnDuty()
	if Config.OnDutyOnly then
		return QBCore.Functions.GetPlayerData().job.onduty
	end
	return true
end

-- Dispatch Itself

local disableNotis, disableNotifSounds = false, false

RegisterNetEvent('dispatch:manageNotifs', function(sentSetting)
	local wantedSetting = tostring(sentSetting)
	if wantedSetting == "on" then
		disableNotis = false
		disableNotifSounds = false
		QBCore.Functions.Notify("Dispatch enabled", "success")
	elseif wantedSetting == "off" then
		disableNotis = true
		disableNotifSounds = true
		QBCore.Functions.Notify("Dispatch disabled", "success")
	elseif wantedSetting == "mute" then
		disableNotis = false
		disableNotifSounds = true
		QBCore.Functions.Notify("Dispatch muted", "success")
	else
		QBCore.Functions.Notify('Please choose to have dispatch as "on", "off" or "mute".', "success")
	end
end)

RegisterNetEvent('dispatch:clNotify', function(sNotificationData, sNotificationId, sender)
	if sNotificationData ~= nil and LocalPlayer.state.isLoggedIn then
	if IsValidJob(sNotificationData['job']) and CheckOnDuty() then
			if not disableNotis then
				if sNotificationData.origin ~= nil then
					SendNUIMessage({
						update = "newCall",
						callID = sNotificationId,
						data = sNotificationData,
						timer = 5000,
						isPolice = Config.AuthorizedJobs.LEO.Check()
					})
					notifyID = sNotificationId
					dispatchMessage = sNotificationData.dispatchMessage
					Waypoint = vector2(sNotificationData.origin.x, sNotificationData.origin.y)
					Wait(5000)
					Waypoint = nil
				end
			end
		end
	end
end)

RegisterCommand('setdispatchgps', function()
	if Waypoint then 
		SetWaypointOff() 
		SetNewWaypoint(Waypoint.x, Waypoint.y)
		TriggerServerEvent('mdt:server:callAttach', notifyID)
		QBCore.Functions.Notify('Attached to call  [#'..notifyID .. '] ' ..dispatchMessage..'.', "success")
	end
end, false)

RegisterKeyMapping('setdispatchgps', 'Set Waypoint', 'keyboard', Config.RespondsKey)


RegisterNetEvent("ps-dispatch:client:AddCallBlip", function(coords, data, blipId)
	if IsValidJob(data.recipientList) and CheckOnDuty() then
		if not disableNotifSounds then
			PlaySound(-1, data.sound, data.sound2, 0, 0, 1)
			TriggerServerEvent("InteractSound_SV:PlayOnSource", data.sound, 0.25) -- For Custom Sounds
		end
		CreateThread(function()
			local alpha = 255
			local blip = nil
			local radius = nil
			local radiusAlpha = 128
			local sprite, colour, scale = 161, 84, 1.0
			local randomoffset = RandomNum(1,100)
			if data.blipSprite then sprite = data.blipSprite end
			if data.blipColour then colour = data.blipColour end
			if data.blipScale then scale = data.blipScale end
			if data.radius then radius = data.radius end
			
			if data.offset == "true" then
				if randomoffset <= 25 then
					radius = AddBlipForRadius(coords.x + RandomNum(Config.MinOffset, Config.MaxOffset), coords.y + RandomNum(Config.MinOffset, Config.MaxOffset), coords.z, data.radius)
					blip = AddBlipForCoord(coords.x + RandomNum(Config.MinOffset, Config.MaxOffset), coords.y + RandomNum(Config.MinOffset, Config.MaxOffset), coords.z)
					blips[blipId] = blip
					radius2[blipId] = radius
				elseif randomoffset >= 26 and randomoffset <= 50 then
					radius = AddBlipForRadius(coords.x - RandomNum(Config.MinOffset, Config.MaxOffset), coords.y + RandomNum(Config.MinOffset, Config.MaxOffset), coords.z, data.radius)
					blip = AddBlipForCoord(coords.x - RandomNum(Config.MinOffset, Config.MaxOffset), coords.y + RandomNum(Config.MinOffset, Config.MaxOffset), coords.z)
					blips[blipId] = blip
					radius2[blipId] = radius
				elseif randomoffset >= 51 and randomoffset <= 74 then
					radius = AddBlipForRadius(coords.x - RandomNum(Config.MinOffset, Config.MaxOffset), coords.y - RandomNum(Config.MinOffset, Config.MaxOffset), coords.z, data.radius)
					blip = AddBlipForCoord(coords.x - RandomNum(Config.MinOffset, Config.MaxOffset), coords.y - RandomNum(Config.MinOffset, Config.MaxOffset), coords.z)
					blips[blipId] = blip
					radius2[blipId] = radius
				elseif randomoffset >= 75 and randomoffset <= 100 then
					radius = AddBlipForRadius(coords.x + RandomNum(Config.MinOffset, Config.MaxOffset), coords.y - RandomNum(Config.MinOffset, Config.MaxOffset), coords.z, data.radius)
					blip = AddBlipForCoord(coords.x + RandomNum(Config.MinOffset, Config.MaxOffset), coords.y - RandomNum(Config.MinOffset, Config.MaxOffset), coords.z)
					blips[blipId] = blip
					radius2[blipId] = radius
				end
			elseif data.offset == "false" then
				radius = AddBlipForRadius(coords.x, coords.y, coords.z, data.radius)
				blip = AddBlipForCoord(coords.x, coords.y, coords.z)
				blips[blipId] = blip
				radius2[blipId] = radius
			end
			if data.blipflash == "true" then 
				SetBlipFlashes(blip, true) 
			elseif data.blipflash == "false" then 
				SetBlipFlashes(blip, false)
			end
			SetBlipSprite(blip, sprite)
			SetBlipHighDetail(blip, true)
			SetBlipScale(blip, scale)
			SetBlipColour(blip, colour)
			SetBlipAlpha(blip, alpha)
			SetBlipAsShortRange(blip, false)
			SetBlipCategory(blip, 2)
			SetBlipColour(radius, colour)
			SetBlipAlpha(radius, radiusAlpha)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(data.displayCode..' - '..data.description)
			EndTextCommandSetBlipName(blip)
			while radiusAlpha ~= 0 do
				Wait(data.blipLength * 1000)
				radiusAlpha = radiusAlpha - 1
				SetBlipAlpha(radius, radiusAlpha)	
				if radiusAlpha == 0 then
					RemoveBlip(radius)
					RemoveBlip(blip)
					return
				end
			end
		end)
	end
end)

RegisterNetEvent('dispatch:getCallResponse', function(message)
	SendNUIMessage({
		update = "newCall",
		callID = RandomNum(1000, 9999),
		data = {
			dispatchCode = 'RSP',
			priority = 1,
			dispatchMessage = "Call Response",
			information = message
		},
		timer = 10000,
		isPolice = true
	})
end)

RegisterNetEvent("ps-dispatch:client:Explosion", function(data)
	exports["ps-dispatch"]:Explosion()
end)

RegisterNetEvent("ps-dispatch:client:removeCallBlip", function(blipId)
	RemoveBlip(blips[blipId])
	RemoveBlip(radius2[blipId])
end)

RegisterNetEvent("ps-dispatch:client:clearAllBlips", function()
	for k, v in pairs(blips) do
		RemoveBlip(v)
	end
	for k, v in pairs(radius2) do
		RemoveBlip(v)
	end
	QBCore.Functions.Notify('All dispatch blips cleared', "success")
end)
