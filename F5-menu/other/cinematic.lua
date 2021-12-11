local cinema = false

RegisterCommand("cinema", function()
	cinema = not cinema
	if cinema then
		SendNUIMessage({
			action = "cinema"
		})

		TriggerEvent("esx_status:setDisplay", 0.0)
		TriggerEvent("ui:toggle")

		while cinema do Wait(0) end
		DisplayRadar(false)
	end

	DisplayRadar(true)

	SendNUIMessage({
		action = "close"
	})

	TriggerEvent("esx_status:setDisplay", 0.5)
	TriggerEvent("ui:toggle", true)
end)