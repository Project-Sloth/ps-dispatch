
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

    ["vehicleshots"] =  {displayCode = '10-13', description = "Shots Fired from Vehicle", radius = 0, recipientList = {'police'}, blipSprite = 648, blipColour = 84, blipScale = 1.5, blipLength = 2 },
	["shooting"] =  {displayCode = '10-13', description ="Shots Fired", radius = 0, recipientList = {'police'}, blipSprite = 648, blipColour = 84, blipScale = 1.5, blipLength = 2 },
	["speeding"] =  {displayCode = '10-13', description = "Speeding", radius = 0, recipientList = {'police'}, blipSprite = 648, blipColour = 84, blipScale = 1.5, blipLength = 2 },
    ["armed"] =  {displayCode = '10-13', description = "Armed Player", radius = 0, recipientList = {'police'}, blipSprite = 648, blipColour = 84, blipScale = 1.5, blipLength = 2 },

}