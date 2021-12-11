ESX = nil
local societymoney = nil
local playerObjects = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    ContinentalUtils.WeaponAfficha = ESX.GetWeaponList()

    for i = 1, #ContinentalUtils.WeaponAfficha, 1 do
        ContinentalUtils.WeaponAfficha[i].hash = GetHashKey(ContinentalUtils.WeaponAfficha[i].name)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job

    DisableSocietyMoneyHUDElement()

    if PlayerData.job.gradejob_name == 'boss' then
    
        EnableSocietyMoneyHUDElement()
  
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyMoneyHUDElement(money)
        end, PlayerData.job.name)

    end
end)

----EVENEMENT

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            print(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	--RefreshMoney()
end)

RegisterNetEvent('Ademo:ii')
AddEventHandler('Ademo:ii', function(value, quantity)
  local weaponHash = GetHashKey(value)

    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
    end
end)

---VARIABLE DANS LE FICHIER
--Piggy back
local openInventory = false
---Callback
local vet
local vet2
local data
---VARIABLE DANS LE FICHIER

--TABLE PEUX ETRE APPELLER N'IMPORTE OU DANS LE DOSSIER
ContinentalUtils = {
    ItemsUse = {}, ---Recupéré l'index de la boucle
    WeaponAfficha = {}, --Recupéré l'index de la boucle
    Facture = {}, --Pour le callback
    FactureSelecte = {}, --Recupéré l'index de la boucle
    Ped = PlayerPedId(), --- Pour récupéré l'id du joueur
    ----ShowBox
    box1 = false,
    box2 = false,
    box3 = false,
    box4 = false,
    box5 = false,
    box6 = false,
    box7 = false,
    box8 = false,
    box9 = false,
    box10 = false,
    box11 = false,
    ---Slider + Progresse
    slide = 50,
    pro = 0,
    heritage = 50,
    --Hud Faim
    Faim = 0,
    Soif= 0,
    --Faire report
    Report1 = false,
    Report2 = false,
    --List portes ++
    list = 1,
    list1 = 1,
    list2 = 1,
}

--TABLE PEUX ETRE APPELLER N'IMPORTE OU DANS LE DOSSIER
ContinentalVeh = {
    VehPed = GetVehiclePedIsIn(ContinentalUtils.Ped, false), -- Pour voir si tes dans un véhicule
    droit = false,
    gauche = false,
    droite1 = false,
    gauche1 = false,
    capot = false,
    allo = false,
    allo1 = false,
}

-- GetVehiclePedIsIn(GetPlayerPed(-1), false)

----MENU

local allmenu = RageUI.CreateMenu("Menu personnel", "~s~")

local Weaponmenu = RageUI.CreateSubMenu(allmenu, "Gestion des armes", "~s~")
local itemMenu =  RageUI.CreateSubMenu(allmenu, "Inventaire", "~s~")
local WeaponMenuuse =  RageUI.CreateSubMenu(Weaponmenu, "Armes", "~s~")
local portMenu =  RageUI.CreateSubMenu(allmenu, "Portefeuille", "~s~")
local portMoneyMenu =  RageUI.CreateSubMenu(portMenu, "Argent", "~s~")
local portMoneySaleMenu =  RageUI.CreateSubMenu(portMenu, "Argent Sale", "~s~")
local portMoneyBankMenu =  RageUI.CreateSubMenu(portMenu, "Portefeuille", "~s~")
local Facture =  RageUI.CreateSubMenu(portMenu, "Facture", "~s~")
local InfoFacture =  RageUI.CreateSubMenu(Facture, "Facture", "~s~")
local Divers =  RageUI.CreateSubMenu(allmenu, "Divers", "~s~")
local Faim =  RageUI.CreateSubMenu(allmenu, "Alimentation", "~s~")
local MyObjects =  RageUI.CreateSubMenu(allmenu, "Objets boutique", "~s~")
local ActionsCivils =  RageUI.CreateSubMenu(allmenu, "Civils", "~s~")
local Menumenu =  RageUI.CreateSubMenu(allmenu, "Menu", "~s~")
local ademoMenu =  RageUI.CreateSubMenu(allmenu, "Options", "~s~")
local menuVeh = RageUI.CreateSubMenu(allmenu, "Vehicles", "~s~")
local menuPatron = RageUI.CreateSubMenu(portMenu, "Emplois", "~s~")
local menuPatron2 = RageUI.CreateSubMenu(portMenu, "Patron", "~s~")
--
--
local allmenu2 = RageUI.CreateMenu("Items", "~s~")
---ACTIVE LA TERRE
allmenu:DisplayGlare(true)
--taille du menu
allmenu:SetStyleSize(100);
allmenu.Closed = function()
    openInventory = false
end

allmenu2:DisplayGlare(true)
--taille du menu
allmenu2:SetStyleSize(100);
allmenu2.Closed = function()
    openInventory = false
end

Weaponmenu:DisplayGlare(true)
Weaponmenu:SetStyleSize(100);
Weaponmenu:DisplayPageCounter(true)

---SUB MENU
itemMenu:DisplayGlare(true)
itemMenu:SetStyleSize(100);
itemMenu:DisplayPageCounter(true)

Weaponmenu:DisplayGlare(true)
Weaponmenu:SetStyleSize(100);
Weaponmenu:DisplayPageCounter(true)

portMenu:DisplayGlare(true)
portMenu:SetStyleSize(100);
portMenu:DisplayPageCounter(true)

portMoneyMenu:DisplayGlare(true)
portMoneyMenu:SetStyleSize(100);
portMoneyMenu:DisplayPageCounter(true)

portMoneySaleMenu:DisplayGlare(true)
portMoneySaleMenu:SetStyleSize(100);
portMoneySaleMenu:DisplayPageCounter(true)

portMoneyBankMenu:DisplayGlare(true)
portMoneyBankMenu:SetStyleSize(100);
portMoneyBankMenu:DisplayPageCounter(true)

WeaponMenuuse:DisplayGlare(true)
WeaponMenuuse:SetStyleSize(100);
WeaponMenuuse:DisplayPageCounter(true)

Divers:DisplayGlare(true)
Divers:SetStyleSize(100);
Divers:DisplayPageCounter(true)

Faim:DisplayGlare(true)
Faim:SetStyleSize(100);
Faim:DisplayPageCounter(true)

Facture:DisplayGlare(true)
Facture:SetStyleSize(100);
Facture:DisplayPageCounter(true)

InfoFacture:DisplayGlare(true)
InfoFacture:SetStyleSize(100);
InfoFacture:DisplayPageCounter(true)

ActionsCivils:DisplayGlare(true)
ActionsCivils:SetStyleSize(100);
ActionsCivils:DisplayPageCounter(true)

Menumenu:DisplayGlare(true)
Menumenu:SetStyleSize(100);
Menumenu:DisplayPageCounter(true)

ademoMenu:DisplayGlare(true)
ademoMenu:SetStyleSize(100);
ademoMenu:DisplayPageCounter(true)

menuVeh:DisplayGlare(true)
menuVeh:SetStyleSize(100);
menuVeh:DisplayPageCounter(true)

menuPatron:DisplayGlare(true)
menuPatron:SetStyleSize(100);
menuPatron:DisplayPageCounter(true)

menuPatron2:DisplayGlare(true)
menuPatron2:SetStyleSize(100);
menuPatron2:DisplayPageCounter(true)

Citizen.CreateThread(function()
    RegisterKeyMapping(GetCurrentResourceName().."_open_inventory", "Ouvrir l'inventaire", 'keyboard', 'f5')
    RegisterCommand(GetCurrentResourceName().."_open_inventory", function()
        if openInventory == false then
            Continental()
        end
    end, false)
end)

function Continental()
    if openInventory then
		openInventory = false
		return
    else
        openInventory = true
        RageUI.Visible(allmenu, true)

    while openInventory do
        RageUI.IsVisible(allmenu, function()
            RageUI.Button('Inventaire', nil, {}, true, {onSelected = function() end}, itemMenu);
            RageUI.Button('Portefeuille', nil, {}, true, {
                onSelected = function() 
                    ESX.TriggerServerCallback('ademo_inventory:Info', function(allo)
                        data = allo
                    end)
            end}, portMenu)
            RageUI.Button('Armement', nil, {}, true, {onSelected = function() end}, Weaponmenu);

            RageUI.Button('Divers', nil, {}, true, {
                
                onSelected = function() 
                    ESX.TriggerServerCallback('ademo_inventory:Info', function(allo)
                        data = allo

                    end)
            end}, Divers);

            RageUI.Button('Alimentation', nil, {}, true, {
                onSelected = function() 
                    ESX.TriggerServerCallback('ademo_inventory:Info', function(allo)
                        data = allo
                    end)
                end
            }, Faim);

        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            RageUI.Button('Véhicule', nil, {RightLabel = "→"}, true, {onSelected = function() end}, menuVeh);
        end

        end, function()
    end)

        RageUI.IsVisible(itemMenu, function()

            RageUI.Separator("[ ~g~Items~s~ ]")

            ESX.PlayerData = ESX.GetPlayerData()
                for i = 1, #ESX.PlayerData.inventory do
                    if ESX.PlayerData.inventory[i].count > 0 then
                        RageUI.Button('~h~x' ..ESX.PlayerData.inventory[i].count.. '~h~ - ' ..ESX.PlayerData.inventory[i].label, nil, {}, true, {
                            onSelected = function()
                                ContinentalUtils.ItemsUse = ESX.PlayerData.inventory[i]
                 
                            end}, allmenu2);  
                        end
                    end
                            
        end,function()
    end)


    ------------MENu

        RageUI.IsVisible(allmenu2, function()

            RageUI.Separator("[ ~g~↓~s~ Actions ~g~↓~s~ ]")

            RageUI.Button('Donner un ~r~item', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    local sonner,quantity = CheckQuantity(KeyboardInput("Somme que vous voulez donner", '', 1000))
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                local pPed = GetPlayerPed(-1)
                                local coords = GetEntityCoords(pPed)
                                local x,y,z = table.unpack(coords)
                                DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
            
                                if sonner then
                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)
            
                                        if IsPedOnFoot(closestPed) then
                                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', ContinentalUtils.ItemsUse.name, quantity)
                                            else
                                                ShowNotification("~∑~ Quantitée invalide !")
                                            end
                                        else
                                            ShowNotification("∑ Aucun joueur ~r~proche !")
                                        end
                                    end
                                end,});

            RageUI.Button('Utiliser un ~r~item', nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, {
                onSelected = function()
                    if ContinentalUtils.ItemsUse then
                        TriggerServerEvent('esx:useItem', ContinentalUtils.ItemsUse.name)
                    else
                        ShowNotification("∑ l\'item n\'est pas utilisable", ContinentalUtils.ItemsUse.label)
                    end
                end, });
            end, function()
        end)

        ------------MENU

        RageUI.IsVisible(menuPatron2, function()

            RageUI.Button('Recruter une personne', nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local job =  ESX.PlayerData.job.name
					local grade = 0
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
				    else
					  TriggerServerEvent('ademo_inventory:recruterplayer', GetPlayerServerId(closestPlayer), job,grade)
				    end
            end});


            RageUI.Button('Virer une personne', nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local job =  ESX.PlayerData.job.name
					local grade = 0
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
				  else
                     TriggerServerEvent('ademo_inventory:virerplayer', GetPlayerServerId(closestPlayer))
				  end
            end});

            RageUI.Button('Promouvoir une personne', nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local job =  ESX.PlayerData.job.name
					local grade = 0
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
				  else
                     TriggerServerEvent('ademo_inventory:promouvoirplayer', GetPlayerServerId(closestPlayer))
                     print('dep')
				  end
            end});

            RageUI.Button('Destituer une personne', nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local job =  ESX.PlayerData.job.name
					local grade = 0
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
				  else
                     TriggerServerEvent('ademo_inventory:destituerplayer', GetPlayerServerId(closestPlayer))
				  end
            end});

           end,function()
       end)

        RageUI.IsVisible(menuPatron, function()
             RageUI.Button('Grade', nil, {RightLabel = "[ ~p~"..ESX.PlayerData.job.grade_label .."~s~ ]"}, true, {
                 onSelected = function()
                 end});

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then   
            RageUI.Button("Gestion d'entreprise", nil, {RightLabel = "→→"}, true, {
                 onSelected = function()

            end}, menuPatron2);
        else
            RageUI.Button("Gestion d'entreprise", nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, {
                onSelected = function()
                    PlaySoundFrontend(-1, "DRUG_TRAFFIC_AIR_BOMB_DROP_ERROR_MASTER", false)
           end});
        end
            end,function()
        end)

        RageUI.IsVisible(portMenu, function()
            
            RageUI.Button('Argent ~g~Liquide', nil, {RightLabel = "→"}, true, {}, portMoneyMenu)

            RageUI.Button('Argent ~r~Sale', nil, {RightLabel = "→"}, true, {}, portMoneySaleMenu)

            RageUI.Button('Carte ~b~Bancaire', nil, {RightLabel = "→"}, true, {}, portMoneyBankMenu);
            
            RageUI.Button('Factures', nil, {}, true, {
                onSelected = function() 
                    ESX.TriggerServerCallback('ademo_inventory:billing', function(bills) ContinentalUtils.Facture = bills end)
                    ESX.TriggerServerCallback('ademo_inventory:Info', function(allo)
                        data = allo
                    end)
                end}, Facture); 

            RageUI.Separator("")

            RageUI.Button('Emploi', nil, {RightLabel = "[ ~b~"..ESX.PlayerData.job.label .."~s~ ]"}, true, {}, menuPatron);

            RageUI.Button('Gang', nil, {RightLabel = "[ ~b~"..ESX.PlayerData.job2.label .."~s~ ]"}, true, {});

            RageUI.Button("Regarder sa ~g~carte d'identité", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                end});

            RageUI.Button("Montrer sa ~g~carte d'identité", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
					end
                end})

            RageUI.Button("Regarder son ~g~permis de conduire", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                end})
            
            RageUI.Button("Montrer son ~g~permis de conduire", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestDistance ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                    else
                        ShowNotification("∑ Aucun joueur ~r~proche~s~ !")
                    end
                end})

            end, function()
        end)


        RageUI.IsVisible(portMoneyMenu, function()
            
            RageUI.Separator(" [~g~"..ESX.Math.GroupDigits(ESX.PlayerData.money.."$~s~]"))
            
            RageUI.Button("Donner de ~g~l'argent", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                onSelected = function()
                    local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', 1000))
                                            if black then
                                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                                        if closestDistance ~= -1 and closestDistance <= 3 then
                                            local closestPed = GetPlayerPed(closestPlayer)
       
                                            if not IsPedSittingInAnyVehicle(closestPed) then
                                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', ESX.PlayerData.money, quantity)
                                            else
                                               ShowNotification('∑ Vous ne pouvez pas donner ', 'de  ~r~l\'argent ~s~ dans un véhicule')
                                            end
                                        else
                                            ShowNotification('∑ Aucun joueur  ~r~proche ~s~ !')
                                        end
                                    else
                                       ShowNotification('∑ Somme ~r~incorrecte !')
                                    end
                                end,});
                            end, function()
                        end)

        RageUI.IsVisible(portMoneySaleMenu, function()
            
            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'black_money'  then
            RageUI.Separator(" [~r~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."$~s~]"))
                RageUI.Button("Donner de ~r~l'argent sale", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                    onSelected = function()
                            local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', 1000))
                                if black then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)

                                if not IsPedSittingInAnyVehicle(closestPed) then
                                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
                                    --RageUI.CloseAll()
                                else
                                    ShowNotification('∑ Vous ne pouvez pas donner ', 'de  ~r~l\'argent ~s~ dans un véhicule')
                                end
                            else
                                ShowNotification('∑ Aucun joueur  ~r~proche ~s~ !')
                            end
                        else
                            ShowNotification('∑ Somme ~r~incorrecte !')
                        end
                    end});
                end
            end
        end, function()
    end)

        RageUI.IsVisible(portMoneyBankMenu, function()
            for i = 1, #ESX.PlayerData.accounts, 1 do
                if ESX.PlayerData.accounts[i].name == 'bank' then
                RageUI.Separator("Solde : [~b~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."$~s~]"))

                RageUI.Button('ID du compte : ', nil, {RightLabel = "[~b~"..PlayerId(PlayerPedId()).."~s~]"}, true, {})

                RageUI.Separator("Informations personnelles")

                RageUI.Button('Nom du compte : ', nil, {RightLabel = "[~b~"..data.lastname.."~s~]"}, true, {})

                RageUI.Button('Prénom du compte : ', nil, {RightLabel = "[~b~"..data.firstname.."~s~]"}, true, {})

                RageUI.Button('Date de naissance : ', nil, {RightLabel = "[~b~"..data.dateofbirth.."~s~]"}, true, {})
            end
        end
    end,function()
end)


        RageUI.IsVisible(Weaponmenu, function()
            RageUI.Separator("[~g~ Armes~s~ ]")
            ESX.PlayerData = ESX.GetPlayerData()
            local ped = PlayerPedId()
            for i = 1, #ContinentalUtils.WeaponAfficha, 1 do
                if HasPedGotWeapon(ped, ContinentalUtils.WeaponAfficha[i].hash, false) then
                    local ammo = GetAmmoInPedWeapon(ped, ContinentalUtils.WeaponAfficha[i].hash)
                        RageUI.Button('[~b~' ..ammo.. '~s~] ~g~- ~s~' ..ContinentalUtils.WeaponAfficha[i].label, nil, {RightLabel = ""}, true, {
                            onSelected = function()
                                ContinentalUtils.ItemsUse = ContinentalUtils.WeaponAfficha[i]
                            end}, WeaponMenuuse);
                        end
                    end              
                end,function()
            end)


            RageUI.IsVisible(WeaponMenuuse, function()

                RageUI.Separator("[ ~g~↓~s~Actions ~g~↓~s~ ]")
                RageUI.Button('Donner des ~g~munitions', nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                    onSelected = function()
                        local post, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', 1000))
    
                    if post then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3 then
                            local closestPed = GetPlayerPed(closestPlayer)
                            local pPed = GetPlayerPed(-1)
                            local coords = GetEntityCoords(pPed)
                            local x,y,z = table.unpack(coords)
                            DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)

                            if IsPedOnFoot(closestPed) then
                                local ammo = GetAmmoInPedWeapon(ContinentalUtils.Ped, ContinentalUtils.ItemsUse.hash)

                                if ammo > 0 then
                                    if quantity <= ammo and quantity >= 0 then
                                        local finalAmmo = math.floor(ammo - quantity)
                                        SetPedAmmo(ContinentalUtils.Ped, ContinentalUtils.ItemsUse.name, finalAmmo)

                                        TriggerServerEvent('AdemoInve:ll', GetPlayerServerId(closestPlayer), ContinentalUtils.ItemsUse.name, quantity)
                                        ShowNotification('∑ Vous avez donné x%s munitions à %s', quantity, GetPlayerName(closestPlayer))
                                        --RageUI.CloseAll()
                                    else
                                        ShowNotification('∑ Vous ne possédez pas autant de munitions sur vous !')
                                    end
                                else
                                    ShowNotification("∑ Vous n'avez pas de munitions sur vous !")
                                end
                            else
                                ShowNotification('∑ Vous ne pouvez pas donner des munitions dans un ~~r~véhicule~s~ !', ContinentalUtils.ItemsUse.label)
                            end
                        else
                            ShowNotification('∑ Aucun joueur ~r~proche~s~ !')
                        end
                    else
                        ShowNotification('∑ Nombre de munition ~r~invalide !')
                    end
                end,});

                    local ped = PlayerPedId()
                    if HasPedGotWeapon(ped, ContinentalUtils.ItemsUse.hash, false) then
                        RageUI.Button("Donner ~r~l'arme", nil, {RightBadge = RageUI.BadgeStyle.Gun}, true, {
                            onSelected = function()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)
                                local pPed = GetPlayerPed(-1)
                                local coords = GetEntityCoords(pPed)
                                local x,y,z = table.unpack(coords)
                                DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
    
                                if IsPedOnFoot(closestPed) then
                                    local ped = PlayerPedId()
                                    local ammo = GetAmmoInPedWeapon(ped, ContinentalUtils.ItemsUse.hash)
                                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', ContinentalUtils.ItemsUse.name, ammo)
                                else
                                    ShowNotification('∑ ~r~Impossible~s~ de donner une arme dans un véhicule', ContinentalUtils.ItemsUse.label)
                                end
                            else
                                ShowNotification('∑ Aucun joueur ~r~proche !')
                            end
                        end,});
                    end
                end, function()
            end)

                RageUI.IsVisible(Facture, function()
                    if #ContinentalUtils.Facture == 0 then
                        RageUI.Button('~r~Aucune facture impayée', nil, {RightLabel = "→"}, true, {
                            onSelected = function()

                            end,});
                        end
                     
                    for i = 1, #ContinentalUtils.Facture do
                        RageUI.Button("Facture ~h~#~g~"..ContinentalUtils.Facture[i].id.."~s~", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ContinentalUtils.FactureSelecte = ContinentalUtils.Facture[i]
                            end}, InfoFacture);
                            end
                        end, function()
                    end)

                RageUI.IsVisible(InfoFacture, function()
                        RageUI.Separator("[ Montant: ~g~"..ESX.Math.GroupDigits(ContinentalUtils.FactureSelecte.amount.."~s~ ]"))

                        RageUI.Button('Nom ', nil, {RightLabel = "[ "..data.lastname.."~s~ ]"}, true, {onSelected = function() end,});

                        RageUI.Button('Prénom ', nil, {RightLabel = "[ "..data.firstname.."~s~ ]"}, true, {onSelected = function() end,});

                        RageUI.Button('Raison ', nil, {RightLabel = "[~r~ "..ContinentalUtils.FactureSelecte.label.."~s~ ]"}, true, {onSelected = function() end,});

                        RageUI.Button('Societé ', nil, {RightLabel = "[ "..ContinentalUtils.FactureSelecte.target.." ]"}, true, {onSelected = function() end,});

                        RageUI.Separator("[ Paiement ]")

                        RageUI.Button('Payer la facture', nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_billing:payBill', function() 
                                    ESX.TriggerServerCallback('ademo_inventory:billing', function(bills) ContinentalUtils.Facture = bills  end)
                                end, ContinentalUtils.FactureSelecte.id)
                            end}, allmenu);

                    end, function()
                end)

                RageUI.IsVisible(Faim, function()
                    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                        RageUI.SliderProgress('Faim', status.val/10000, 100, nil, {
                            ProgressBackgroundColor = { R = 98, G = 180, B = 50, A = 75 }, 
                            ProgressColor = { R = 98, G = 180, B = 50, A = 155 },
                        }, true, {})
                    end)
                    
                    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                        RageUI.SliderProgress('Hydratation', status.val/10000, 100, nil, {
                            ProgressBackgroundColor = { R = 86, G = 194, B = 244, A = 75 },
                            ProgressColor = { R = 0, G = 85, B = 244, A = 155 },
                        }, true, {})
                    end)

                    end, function()
                end)
                    
                RageUI.IsVisible(Divers, function()


                    RageUI.Button('Actions Civils', nil, {RightLabel = "→"}, true, {onSelected = function() end}, ActionsCivils);
                    RageUI.Button('Options', nil, {RightLabel = "→"}, true, {onSelected = function() end}, ademoMenu);
                    RageUI.Button("Autre", nil, {RightLabel = "→"}, true, {onSelected = function() end}, Menumenu);


                        if ContinentalUtils.Faim < 0 or ContinentalUtils.Soif < 0 then
                            SetEntityHealth(GetPlayerPed(-1),0)
                        end
                    end, function()
                end)

                RageUI.IsVisible(ActionsCivils, function()

                    RageUI.Checkbox('Porter une personne', nil, ContinentalUtils.box1, {}, {
                        onChecked = function()
                            ExecuteCommand("piggyBack")
                        end,
                        onUnChecked = function()
                            ExecuteCommand("piggyBack")
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box1 = Index
                        end
                    })

                    RageUI.Checkbox('Dormir/Se Réveiller', nil, ContinentalUtils.box2, {}, {
                        onChecked = function()
                            ragdolling = not ragdolling
                            while ragdolling do
                             Wait(0)
                            local myPed = GetPlayerPed(-1)
                            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                            ResetPedRagdollTimer(myPed)
                            AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~réveiller !'))
                            DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                            ResetPedRagdollTimer(myPed)
                            if IsControlJustPressed(0, 22) then 
                            break
                                end
                            end
                        end,
                        onUnChecked = function()
    
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box2 = Index
                            --- Logic on selected items
                        end
                    })

                RageUI.Checkbox('Prendre en otage', nil, ContinentalUtils.box8, {}, {
                    onChecked = function()
                        takeHostage()
                        RageUI.CloseAll()
                        openInventory = false
                    end,
                    onUnChecked = function()

                    end,
                    onSelected = function(Index)
                        ContinentalUtils.box8 = Index
                    end
                })

                RageUI.Checkbox('Poser un bmx', nil, ContinentalUtils.box13, {}, {
                    onChecked = function()
                        ExecuteCommand("bmx")
                        RageUI.CloseAll()
                        openInventory = false
                    end,
                    onUnChecked = function()
                    end,
                    onSelected = function(Index)
                        ContinentalUtils.box13 = Index
                    end
                })

                    end, function()
                end)

                RageUI.IsVisible(Menumenu, function()
    
                     RageUI.Progress('Liste de couleurs & filtres', ContinentalUtils.pro, 18, nil, true, true, function(Hovered, Active, Selected, Index)
                         if (Active) then
                             if Index == 0 then
                                SetTimecycleModifier('default')
                             elseif Index == 1 then
                                 SetTimecycleModifier('rply_contrast_neg')
                             elseif Index == 2 then
                                 SetTimecycleModifier('rply_vignette')
                             elseif Index == 3 then
                                 SetTimecycleModifier('yell_tunnel_nodirect')
                             elseif Index == 4 then
                                 SetTimecycleModifier('PPPurple01')
                             elseif Index == 5 then
                                 SetTimecycleModifier('BombCamFlash')
                             elseif Index == 6 then
                                 SetTimecycleModifier('canyon_mission')
                             elseif Index == 7 then
                                 SetTimecycleModifier('player_transition_no_scanlines')
                             elseif Index == 8 then
                                 SetTimecycleModifier('New_sewers')
                             elseif Index == 9 then
                                 SetTimecycleModifier('NG_filmic20')
                             elseif Index == 10 then
                                 SetTimecycleModifier('BeastIntro01')
                             elseif Index == 11 then
                                 SetTimecycleModifier('spectator2')
                             elseif Index == 12 then
                                 SetTimecycleModifier('v_abattoir')
                             elseif Index == 13 then
                                 SetTimecycleModifier('v_bahama')
                             elseif Index == 14 then
                                 SetTimecycleModifier('v_cashdepot')
                             elseif Index == 15 then
                                 SetTimecycleModifier('Tunnel')
                             elseif Index == 16 then
                                 SetTimecycleModifier('rply_saturation')
                             elseif Index == 17 then
                                 SetTimecycleModifier('BombCamFlash')
                             elseif Index == 18 then
                                 SetTimecycleModifier('rply_saturation_neg')
                             elseif Index == 19 then
                                 SetTimecycleModifier('li')
                             elseif Index == 20 then
                                 SetTimecycleModifier('SALTONSEA')
                             elseif Index == 22 then
                                 SetTimecycleModifier('cinema')
                             end
                         end
                         ContinentalUtils.pro = Index;
                 end)


                 RageUI.Separator("", nil, {}, true, function(_, _, _) end)

                 RageUI.Button('Steam', nil, {RightLabel = "[ "..GetPlayerName(PlayerId()).." ]"}, true, {onSelected = function() end,});
                 RageUI.Button('ID', nil, {RightLabel = "[ "..GetPlayerServerId(PlayerId()).." ]"}, true, {onSelected = function() end,});

                 RageUI.Separator("", nil, {}, true, function(_, _, _) end)

                 RageUI.Button('Report', nil, {RightLabel = ""}, true, {
                     onSelected = function() 
                        local report = KeyboardInput('Report', '', 1000)
                        ExecuteCommand("report " ..report.. " ")
                        RageUI.CloseAll()
                        openInventory = false
                    end,});
                end, function()
            end)


                RageUI.IsVisible(ademoMenu, function()
                    RageUI.Checkbox('Activer/Désactiver la minimap', nil, ContinentalUtils.box3, {}, {
                        onChecked = function()
                            DisplayRadar(true)
                        end,
                        onUnChecked = function()
                            DisplayRadar(false)
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box3 = Index
                        end
                    })

                    RageUI.Checkbox('Activer/Désactiver la barre cinématique', nil, ContinentalUtils.box6, {}, {
                        onChecked = function()
                            SendNUIMessage({openCinema = true})
                                ExecuteCommand("Cinema")
                                ESX.UI.HUD.SetDisplay(0.0)
                                TriggerEvent('es:setMoneyDisplay', 0.0)
                                TriggerEvent('esx_status:setDisplay', 0.0)
                                DisplayRadar(false)
                        end,
                        onUnChecked = function()
                            SendNUIMessage({openCinema = false})
                            ExecuteCommand("Cinema")
                            ESX.UI.HUD.SetDisplay(1.0)
                            TriggerEvent('es:setMoneyDisplay', 1.0)
                            TriggerEvent('esx_status:setDisplay', 1.0)
                            DisplayRadar(true)
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box6 = Index
                        end
                    })

                    RageUI.Checkbox('Activer/Désactiver le crosshair', nil, ContinentalUtils.box9, {}, {
                        onChecked = function()
                            ESX.ShowNotification('~g~Modification effectuée !')
			                TriggerEvent("cookcrosshair:active")
                        end,
                        onUnChecked = function()
                            ESX.ShowNotification('~g~Modification effectuée !')
			                TriggerEvent("cookcrosshair:active")
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box9 = Index
                        end
                    })

                    RageUI.Checkbox('Éditer son crosshair', nil, ContinentalUtils.box10, {}, {
                        onChecked = function()
                            ESX.ShowNotification('~g~Menu ouvert !')
			                TriggerEvent("cookcrosshair:edit")
                        end,
                        onUnChecked = function()
			                TriggerEvent("cookcrosshair:edit")
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box10 = Index
                        end
                    })

                    RageUI.Checkbox('Afficher l\'id en face', nil, ContinentalUtils.box11, {}, {
                        onChecked = function()
                            ExecuteCommand("id")
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box11 = Index
                        end
                    })

                    end, function()
                end)

                RageUI.IsVisible(menuVeh, function()

                    RageUI.List('Conduite', {
                        { Name = "Normale", Value = 1 },
                        { Name = "Sportive", Value = 2 },
                        { Name = "HyperSportive", Value = 3 },
                        { Name = "Arrêt", Value = 4 },

                    }, 
                    ContinentalUtils.list, nil, {}, true, {
                        onListChange = function(Index, Item)
                            ContinentalUtils.list = Index;
                        end,
                        onSelected = function(Index, Item)
                            if Index == 1 then
                                AutoPilote("ConduiteNormal")
                                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'conduite_normale', 0.5)
                            elseif Index == 2 then
                                AutoPilote("ConduiteRapide")
                                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'conduite_dangereuse', 0.5)
                            elseif Index == 3 then
                                AutoPilote("ConduiteRapideSafe")
                                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'conduite_rapide', 0.5)
                            elseif Index == 4 then
                                ClearPedTasks(GetPlayerPed(-1))
                                AutoPiloteActif = false
                                VehList = {}
                            end
                        end,
                    })

                    RageUI.Separator("", nil, {}, true, function(_, _, _) end)

                    RageUI.Checkbox('Allumer/Eteindre le moteur', nil, ContinentalUtils.box4, {}, {
                        onChecked = function()
                            SetVehicleEngineOn(GetVehiclePedIsIn( GetPlayerPed(-1), false ), false, false, true)
                            SetVehicleUndriveable(GetVehiclePedIsIn( GetPlayerPed(-1), false ), true)
                            ESX.ShowNotification('Vous avez éteint votre moteur !')
                        end,
                        onUnChecked = function()
                            SetVehicleEngineOn(GetVehiclePedIsIn( GetPlayerPed(-1), false ), true, false, true)
                            SetVehicleUndriveable(GetVehiclePedIsIn( GetPlayerPed(-1), false ), false)
                            ESX.ShowNotification('Vous avez démarré votre moteur !')
                        end,
                        onSelected = function(Index)
                            ContinentalUtils.box4 = Index
                        end
                    })

                    RageUI.Checkbox('Ouvrir/Fermer le coffre', nil, ContinentalVeh.allo, {}, {
                        onChecked = function()
                            if not ContinentalVeh.allo then
                                ContinentalVeh.allo = true
                                SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, false, false)
                                ESX.ShowNotification('Vous avez ouvert votre ~g~coffre !')
                            elseif ContinentalVeh.allo then
                                ContinentalVeh.allo = false
                                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, false, false)
                                ESX.ShowNotification('Vous avez fermé votre ~r~coffre !')
                                end
                        end,
                        onUnChecked = function()
                            ContinentalVeh.allo = false
                            SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, false, false)
                            ESX.ShowNotification('Vous avez fermé votre ~r~coffre !')
                        end,
                        onSelected = function(Index)
                            ContinentalVeh.allo = Index
                        end
                    })

                    RageUI.Checkbox('Ouvrir/Fermer le capot', nil, ContinentalVeh.capot, {}, {
                        onChecked = function()
                            if not ContinentalVeh.capot then
                                ContinentalVeh.capot = true
                                SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, false, false)
                                ESX.ShowNotification('Vous avez ouvert votre ~g~capot !')
                            elseif ContinentalVeh.capot then
                                ContinentalVeh.capot = false
                                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, false, false)
                                ESX.ShowNotification('Vous avez fermé votre ~r~capot !')
                                end
                        end,
                        onUnChecked = function()
                            ContinentalVeh.capot = false
                            SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, false, false)
                            ESX.ShowNotification('Vous avez fermé votre ~r~capot !')
                        end,
                        onSelected = function(Index)
                            ContinentalVeh.capot = Index
                        end
                    })

                    RageUI.List('Options des portes', {
                        { Name = "Avant Droit", Value = 1 },
                        { Name = "Arrière Gauche", Value = 2 },
                        { Name = "Arrière Droite", Value = 3 },
                        { Name = "Avant Gauche", Value = 4 }, 

                    }, ContinentalUtils.list1, nil, {}, true, {
                        onListChange = function(Index, Item)
                            ContinentalUtils.list1 = Index;
                        end,
                        onSelected = function(Index, Item)
                            if Index == 1 then
                                if not ContinentalVeh.droit then
                                    ContinentalVeh.droit = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, false, false)
                                elseif ContinentalVeh.droit then
                                    ContinentalVeh.droit = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, false, false)
                                end
                            elseif Index == 2 then
                                if not ContinentalVeh.gauche then
                                    ContinentalVeh.gauche = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, false, false)
                                elseif ContinentalVeh.gauche then
                                    ContinentalVeh.gauche = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, false, false)
                                    end
                            elseif Index == 3 then
                                if not ContinentalVeh.droite1 then
                                    ContinentalVeh.droite1 = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, false, false)
                                elseif ContinentalVeh.droite1 then
                                    ContinentalVeh.droite1 = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, false, false)
                                    end
                            elseif Index == 4 then
                                SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0,ContinentalVeh.gauche1)
                                ContinentalVeh.gauche1 = not ContinentalVeh.gauche1
                            end
                        end,
                    })

                    RageUI.Separator("", nil, {}, true, function(_, _, _) end)

                    RageUI.Button('Plaque', nil, {RightLabel = "[ ~r~"..GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)).."~s~ ]"}, true, {onSelected = function() end,});     
                    local moteurveh = math.floor(GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10,2)
                    local carosserieVeh = math.floor(GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10,2)
                    local etat = (moteurveh + carosserieVeh) /2
                    RageUI.Button('État du ~y~Moteur', nil, {RightLabel = "[ ~y~"..moteurveh.."~s~ ]"}, true, {onSelected = function() end,});   
                    
                    RageUI.Button('État de la ~o~Carosserie', nil, {RightLabel = "[ ~o~"..carosserieVeh.."~s~ ]"}, true, {onSelected = function() end,});  

                    end, function()
                end)
                Wait(1)
            end
        end
    end

RegisterNetEvent("realShop:sendAllData")
AddEventHandler("realShop:sendAllData", function(data)
    playerObjects = data
end)

--Give

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- mixing async with sync tasks
function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterCommand("bmx", function(source)
    local Spawned = false
    local _ped = PlayerPedId()
    local mCoords = GetEntityCoords(_ped)
    local mHead = GetEntityHeading(_ped)
    local hash = GetHashKey("bmx")
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    local Vehicle = CreateVehicle(hash, mCoords, mHead, true, false)

    TaskWarpPedIntoVehicle(_ped, Vehicle, -1)
end)