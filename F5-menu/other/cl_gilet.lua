Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
  end)

RegisterNetEvent("gilet:EquipGiletSimple")
AddEventHandler("gilet:EquipGiletSimple", function()
    GiletSimple()
end)

RegisterNetEvent("gilet:EquipGiletLourd")
AddEventHandler("gilet:EquipGiletLourd", function()
    GiletLourd() 
end)

--RegisterCommand("giletsimple", function(source, args, rawCommand)
    --GiletSimple() 
--end, false)

--RegisterCommand("giletlourd", function(source, args, rawCommand)
    --GiletLourd()
--end, false)

local obj = GetHashKey("prop_cs_heist_bag_02")

local UnGlitch = false

function GiletSimple()
    local pPed = GetPlayerPed(-1)
    local coords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.7, -1.0)
    
    RequestModel(obj)
    while not HasModelLoaded(obj) do Wait(10) end
    local object = CreateObject(obj, coords, 1, 0, 0)
    FreezeEntityPosition(object, 1)
    TaskStartScenarioInPlace(pPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
    UnGlitch = true
    AntiChlitch()
    Wait(6500)
    SetPedArmour(pPed, 50)
    TriggerEvent("skinchanger:change", 'bproof_1', 11)
    PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
    ClearPedTasks(pPed)
    --DeleteEntity(object)
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
    UnGlitch = false
    ESX.ShowNotification('~g~Vous avez inséré votre gilet simple !')
end

function GiletLourd()
    local pPed = GetPlayerPed(-1)
    local coords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.7, -1.0)
    
    RequestModel(obj)
    while not HasModelLoaded(obj) do Wait(10) end
    local object = CreateObject(obj, coords, 1, 0, 0)
    FreezeEntityPosition(object, 1)
    TaskStartScenarioInPlace(pPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, 1)
    UnGlitch = true
    AntiChlitch()
    Wait(6500)
    SetPedArmour(pPed, 200)
    TriggerEvent("skinchanger:change", 'bproof_1', 9)
    PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
    ClearPedTasks(pPed)
    --DeleteEntity(object)
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
    UnGlitch = false
    ESX.ShowNotification('~g~Vous avez inséré votre gilet lourd !')
end

function AntiChlitch()
    Citizen.CreateThread(function()
        while UnGlitch do
            Wait(1)
            DisableControlAction(1, 73, 1)
            DisableControlAction(1, 166, 1)
            DisableControlAction(1, 170, 1)
        end
        ClearPedTasks(GetPlayerPed(-1))
    end)
end