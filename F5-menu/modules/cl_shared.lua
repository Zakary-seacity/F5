function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function CheckQuantity(number)
    number = tonumber(number)
  
    if type(number) == 'number' then
      number = ESX.Math.Round(number)
  
      if number > 0 then
        return true, number
      end
    end
  
    return false, number
  end
  
  function KeyboardInput(entryTitle, inputText, maxLength)
      AddTextEntry(entryTitle, "")
      DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    
      while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
      end
    
      if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
      else
        Citizen.Wait(500)
        return nil
      end
    end
  

    function startAnimAction(lib, anim)
      ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ContinentalUtils.Ped, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
        RemoveAnimDict(lib)
      end)
    end


  ----PIGGY BACK
    


AutoPiloteActif = false
function AutoPilote(Conduite)
	local style
	local speed
	if Conduite == "ConduiteNormal" then
		style = 786603
		speed = 25.0
	elseif Conduite == "ConduiteRapide" then
		style = 1074528293
		speed = 450.0
	elseif Conduite == "ConduiteRapideSafe" then
		style = 2883621
		speed = 25.0
	end
	-- Conduite
	local way = IsWaypointActive()
	if way then
		local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
		local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
		local PlayerPed = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(PlayerPed, false)
        local hash = GetHashKey(veh)
        local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), destination, true), 0)

        TaskVehicleDriveToCoord(PlayerPed, veh, coords.x, coords.y, coords.z, speed, 1.0, hash, style, 5.0, true)

        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
        notify("CHAR_LS_TOURIST_BOARD", 2, "Auto Pilote", "~b~Informations", "Auto Pilote : ~g~ON~w~\nDistance: Vous êtes à ~g~"..distance.." mètres", 2)

        destination = coords
        AutoPiloteActif = true
	else
        notify("CHAR_LS_TOURIST_BOARD", 2, "Auto Pilote", "~b~Informations", "Auto Pilote : ~r~OFF~w~\nAucun point GPS n'a été affiché !", 2)
	end
end

VehList = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if marker then
            if AutoPiloteActif then
                VehList = {}
                local voiture = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1), true), 30) -- Changer ça si trop de MS utilisé
                for _, voiture in pairs(voiture) do
                    if voiture ~= GetVehiclePedIsIn(GetPlayerPed(-1), 0) then
                        table.insert(VehList, voiture)
                    end
                end
            end  
        end  
    end
end)

Citizen.CreateThread(function()
	while true do
		local nearThing = false
        if marker then
            for _, voiture in pairs(VehList) do
                local coords = GetEntityCoords(voiture, true)
                local distanceChemin = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), destination, true), 0)
				if distanceChemin <= 10.0 then
					nearThing = true
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'end_desti', 0.5)
                    ClearPedTasks(GetPlayerPed(-1))
                    AutoPiloteActif = false
                    VehList = {}
                end
            end
		end
		
		if nearThing then
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end
    end
end)

function notify(icon, type, sender, title, text, color)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationBackgroundColor(color)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
    PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
end

function ShowNotif(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == "mask" then
				elseif _accessory == 'glasses' then
					mAccessory = 0
				elseif _accessory == 'helmet' then
				elseif _accessory == 'mask' then
		
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
    else
  
			if _accessory == 'glasses' then
        notify("CHAR_BUGSTARS", 2, "Inventaire", "~b~Accessoires", "Vous ~r~n'avez pas~s~ de ~g~lunette~s~", 2)
			elseif _accessory == 'helmet' then
        notify("CHAR_BUGSTARS", 2, "Inventaire", "~b~Accessoires", "Vous ~r~n'avez pas~s~ de ~g~chapeau/bonnet", 2)
			elseif _accessory == 'mask' then
        notify("CHAR_BUGSTARS", 2, "Inventaire", "~b~Accessoires", "Vous ~r~n'avez pas~s~ de ~g~masque", 2)
      elseif _accessory == 'ears' then
        notify("CHAR_BUGSTARS", 2, "Inventaire", "~b~Accessoires", "Vous ~r~n'avez pas~s~ ~g~d'accessoires d'oreille", 2)
      end
		end
	end, accessory)
end

