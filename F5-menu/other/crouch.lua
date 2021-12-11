local crouched = false

Citizen.CreateThread(function()
    RegisterKeyMapping(GetCurrentResourceName().."_crouch", "S'accroupir", 'keyboard', '')
    RegisterCommand(GetCurrentResourceName().."_crouch", function()
        if not crouched then
            RequestAnimSet("move_ped_crouched")
            while (not HasAnimSetLoaded("move_ped_crouched")) do 
                Citizen.Wait(100)
            end
            SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)
            crouched = true

            Citizen.CreateThread(function()
                while crouched do

                    SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)

                    Citizen.Wait(500)
                end
            end)
        else
            ResetPedMovementClipset(PlayerPedId(), 0)
            crouched = false
        end
    end, false)
end)