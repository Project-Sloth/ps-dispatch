CreateThread(function()
	local sleep = 100
	while true do
        if (not isPlayerWhitelisted or Config.Debug) then
            for k, v in pairs(Config.Timer) do
                if v > 0 then Config.Timer[k] = v - 1 end
            end
        end
		Wait(sleep)
	end
end)