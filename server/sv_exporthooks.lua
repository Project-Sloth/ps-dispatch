--------------------------------------------------------------
-- Purpose: 	Export hooks for the server <--> client
--------------------------------------------------------------

local function getNetworkId(entity)
  if DoesEntityExist(entity) then
    return NetworkGetNetworkIdFromEntity(entity)
  end
  return entity
end

---@param source number Player source
---@param vehicle number Vehicle network id or server entity id
---@param coords vector3|nil Location of the vehicle theft or nil
exports('VehicleTheft', function(source, vehicle, coords)
  TriggerClientEvent('dispatch:client:vehicletheft', source, getNetworkId(vehicle), coords)
end)

---@param source number Player source
---@param vehicle number Vehicle network id or server entity id
---@param coords vector3|nil Location of the vehicle shooting or nil
exports('VehicleShooting', function(source, vehicle, coords)
  TriggerClientEvent('dispatch:client:vehicleshooting', source, getNetworkId(vehicle), coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the shooting or nil
exports('Shooting', function(source, coords)
  TriggerClientEvent('dispatch:client:shooting', source, coords)
end)

---@param source number Player source
---@param vehicle number Vehicle network id or server entity id
---@param coords vector3|nil Location of the speeding vehicle or nil
exports('Speeding', function(source, vehicle, coords)
  TriggerClientEvent('dispatch:client:speeding', source, getNetworkId(vehicle), coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the fight or nil
exports('Fight', function(source, coords)
  TriggerClientEvent('dispatch:client:fight', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the down or nil
exports('InjuriedPerson', function(source, coords)
  TriggerClientEvent('dispatch:client:injuriedperson', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the death or nil
exports('DeceasedPerson', function(source, coords)
  TriggerClientEvent('dispatch:client:deceasedperson', source, coords)
end)

---@param source number Player source
---@param camId number Camera id
---@param coords vector3|nil Location of the robbery or nil
exports('StoreRobbery', function(source, camId, coords)
  TriggerClientEvent('dispatch:client:storerobbery', source, camId, coords)
end)

---@param source number Player source
---@param camId number Camera id
---@param coords vector3|nil Location of the robbery or nil
exports('FleecaBankRobbery', function(source, camId, coords)
  TriggerClientEvent('dispatch:client:fleecabankrobbery', source, camId, coords)
end)

---@param source number Player source
---@param camId number Camera id
---@param coords vector3|nil Location of the robbery or nil
exports('PaletoBankRobbery', function(source, camId, coords)
  TriggerClientEvent('dispatch:client:paletobankrobbery', source, camId, coords)
end)

---@param source number Player source
---@param camId number Camera id
---@param coords vector3|nil Location of the robbery or nil
exports('PacificBankRobbery', function(source, camId, coords)
  TriggerClientEvent('dispatch:client:pacificbankrobbery', source, camId, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the prison breakee or nil
exports('PrisonBreak', function(source, coords)
  TriggerClientEvent('dispatch:client:prisonbreak', source, coords)
end)

---@param source number Player source
---@param camId number Camera id
---@param coords vector3|nil Location of the robbery or nil
exports('VangelicoRobbery', function(source, camId, coords)
  TriggerClientEvent('dispatch:client:vangelicorobbery', source, camId, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the robbery or nil
exports('HouseRobbery', function(source, coords)
  TriggerClientEvent('dispatch:client:houserobbery', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the robbery or nil
exports('YachtHeist', function(source, coords)
  TriggerClientEvent('dispatch:client:yachtheist', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the sale or nil
exports('DrugSale', function(source, coords)
  TriggerClientEvent('dispatch:client:drugsale', source, coords)
end)

---@param source number Player source
---@param vehicle number Vehicle network id or server entity id
---@param coords vector3|nil Location of the sale or nil
exports('CarJacking', function(source, vehicle, coords)
  TriggerClientEvent('dispatch:client:carjacking', source, getNetworkId(vehicle), coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the downed officer or nil
exports('OfficerDown', function(source, coords)
  TriggerClientEvent('dispatch:client:officerdown', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the downed EMS or nil
exports('EmsDown', function(source, coords)
  TriggerClientEvent('dispatch:client:emsdown', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the explosion or nil
exports('Explosion', function(source, coords)
  TriggerClientEvent('dispatch:client:explosion', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the suspicious activity or nil
exports('SuspiciousActivity', function(source, coords)
  TriggerClientEvent('dispatch:client:susactivity', source, coords)
end)

---@param source number Player source
---@param coords vector3|nil Location of the suspected hunter or nil
exports('Hunting', function(source, coords)
  TriggerClientEvent('dispatch:client:hunting', source, coords)
end)

---@param source number Player source
---@param data table Custom Call data table
exports('CustomAlert', function(source, data)
  TriggerClientEvent('dispatch:client:customalert', source, data)
end)