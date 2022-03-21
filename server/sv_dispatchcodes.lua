
--[[
	["vehicleshots"] -> dispatchcodename that you pass with the event of AlertGunShot
	displayCode -> Code to be displayed on the blip message
	description -> Description of the blip message
	radius -> to draw a circle with radius around blip
	recipientList -> list of job names that can see the blip
	blipSprite -> blip sprite
	blipColour -> blip colour
	blipScale -> blip scale
	blipLength -> time in seconds at which the blip will fade down, lower the time, faster it will fade. Cannot be 0
]]--

dispatchCodes = {

    ["vehicleshots"] =  {displayCode = '10-13', description = "Shots Fired from Vehicle", radius = 0, recipientList = {'police'}, blipSprite = 119, blipColour = 1, blipScale = 1.5, blipLength = 2 },
	["shooting"] =  {displayCode = '10-13', description ="Shots Fired", radius = 0, recipientList = {'police'}, blipSprite = 110, blipColour = 1, blipScale = 1.5, blipLength = 2 },
	["speeding"] =  {displayCode = '10-13', description = "Speeding", radius = 0, recipientList = {'police'}, blipSprite = 326, blipColour = 84, blipScale = 1.5, blipLength = 2 },
    ["fight"] =  {displayCode = '10-10', description = "Fight In Progress", radius = 0, recipientList = {'police'}, blipSprite = 685, blipColour = 69, blipScale = 1.5, blipLength = 2 },
	["civdown"] =  {displayCode = '10-69', description = "Civilan Down", radius = 0, recipientList = {'ambulance'}, blipSprite = 126, blipColour = 3, blipScale = 1.5, blipLength = 2 },
    ["storerobbery"] =  {displayCode = '10-90', description = "Store Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 52, blipColour = 1, blipScale = 1.5, blipLength = 2 },
	["bankrobbery"] =  {displayCode = '10-90', description = "Fleeca Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 2, blipScale = 1.5, blipLength = 2 },
	["paletobankrobbery"] =  {displayCode = '10-90', description = "Paleto Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 12, blipScale = 1.5, blipLength = 2 },
	["pacificbankrobbery"] =  {displayCode = '10-90', description = "Pacific Bank Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 500, blipColour = 5, blipScale = 1.5, blipLength = 2 },
	["vangelicorobbery"] =  {displayCode = '10-90', description = "Vangelico Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 434, blipColour = 5, blipScale = 1.5, blipLength = 2 },
	["houserobbery"] =  {displayCode = '10-90', description = "House Robbery In Progress", radius = 0, recipientList = {'police'}, blipSprite = 40, blipColour = 5, blipScale = 1.5, blipLength = 2 },
	["suspicioushandoff"] =  {displayCode = '10-60', description = "Suspicious Hand off", radius = 0, recipientList = {'police'}, blipSprite = 469, blipColour = 52, blipScale = 1.5, blipLength = 2 },
}
