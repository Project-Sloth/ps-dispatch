CreateThread(function()
	local sleep = 100
	while true do
        if LocalPlayer.state.isLoggedIn then
            if (not Config.AuthorizedJobs.LEO.Check() or Config.Debug) then
                for k, v in pairs(Config.Timer) do
                    if v > 0 then Config.Timer[k] = v - 1 end
                end
            end
        end
        Wait(sleep)
	end
end)