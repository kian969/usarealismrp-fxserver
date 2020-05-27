local MENU_KEY = 38 -- "E"

local vehicles = {
  { name = "Quad Bike", hash = GetHashKey("blazer") },
  { name = "CVPI", hash = GetHashKey("pdcvpi") },
  { name = "Charger", hash = GetHashKey("pdchgr") },
  { name = "Taurus", hash = GetHashKey("pdtau") },
  { name = "Explorer", hash = GetHashKey("pdexp") },
  { name = "Truck", hash = GetHashKey("sheriff2") },
  { name = "Riot", hash = GetHashKey("riot") },
  { name = "Motorcycle 1", hash = GetHashKey("policeb") },
  { name = "Motorcycle 2", hash = GetHashKey("1200RT") },
  { name = "Golf Cart", hash = GetHashKey("caddy") },
  { name = "Prison Bus", hash = GetHashKey("pbus") },
  { name = "Transport Van", hash = GetHashKey("policet") }
}

local PRISON_GUARD_SIGN_IN_LOCATIONS = {
	{x = 1690.71484375, y = 2591.3149414063, z = 45.914203643799},
	{x = 1849.0, y = 2599.5, z = 45.8} -- front
}

local policeoutfitamount = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local MAX_COMPONENT = 220
local MAX_COMPONENT_TEXTURE = 100
local MAX_PROP = 220
local MAX_PROP_TEXTURE = 100
local arrSkinGeneralCaptions = {"LSPD Male","LSPD Female","Motor Unit","SWAT","Sheriff Male","Sheriff Female","Traffic Warden","Custom Male","Custom Female","FBI 1","FBI 2","FBI 3","FBI 4","Detective Male","Detective Female","Ranger Male", "Ranger Female", "Tactical", "Pilot"}
local arrSkinGeneralValues = {"s_m_y_cop_01","s_f_y_cop_01","S_M_Y_HwayCop_01","S_M_Y_SWAT_01","S_M_Y_Sheriff_01","S_F_Y_Sheriff_01","ig_trafficwarden","mp_m_freemode_01","mp_f_freemode_01","mp_m_fibsec_01","ig_stevehains","ig_andreas","s_m_m_fiboffice_01","s_m_m_ciasec_01","ig_karen_daniels","S_M_Y_Ranger_01","S_F_Y_Ranger_01", "s_m_y_blackops_01", "s_m_m_pilot_02"}
local arrSkinHashes = {}
for i=1,#arrSkinGeneralValues do
  arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
end
local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
local props = { "Head", "Glasses", "Ear Acessories", "Watch"}
local MENU_OPEN_KEY = 38
local closest_shop = nil

RegisterNetEvent("doc:setciv")
AddEventHandler("doc:setciv", function(character, playerWeapons)
    Citizen.CreateThread(function()
        local model
        if not character.hash then -- does not have any customizations saved
            model = -408329255 -- some random black dude with no shirt on, lawl
        else
            model = character.hash
        end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        -- give model customizations if available
        if character.hash then
            for key, value in pairs(character["components"]) do
                --if tonumber(key) ~= 0 or tonumber(key) ~= 1 or tonumber(key) ~= 2 then -- emit barber shop features
                SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
                --end
            end
            for key, value in pairs(character["props"]) do
                SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
            end
        end
        -- add any tattoos if they have any --
        if character.tattoos then
            --print("applying tattoos!")
            for i = 1, #character.tattoos do
                ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
            end
        end
        -- add any barber shop customizations if any --
        if character.head_customizations then
            --print("barber shop customizations existed!")
            local head = character.head_customizations
            local ped = GetPlayerPed(-1)
            SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
            -- facial stuff like beards and ageing and what not --
            for i = 1, #head.other do
                SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
                if head.other[i][2] ~= 255 then
                    if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
                        SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
                    elseif i == 6 or i == 9 then -- blush, lipstick
                        SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
                    elseif i == 14 then -- hair
                        --print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
                        SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
                        SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
                    end
                end
            end
        end
        -- give weapons
        if playerWeapons then
            for i = 1, #playerWeapons do
                GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
                if playerWeapons[i].components then
                    if #playerWeapons[i].components > 0 then
                        for x = 1, #playerWeapons[i].components do
                            GiveWeaponComponentToPed(GetPlayerPed(-1), playerWeapons[i].hash, GetHashKey(playerWeapons[i].components[x]))
                        end
                    end
                end
                if playerWeapons[i].tint then
                    SetPedWeaponTintIndex(GetPlayerPed(-1), playerWeapons[i].hash, playerWeapons[i].tint)
                end
            end
        end
    end)
end)

-- Functions --
function DrawText3D(x, y, z, distance, text)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end


RegisterNetEvent("doc:spawnVehicle")
AddEventHandler("doc:spawnVehicle", function(hash)
  SpawnVehicle(hash)
end)

RegisterNetEvent("doc:open")
AddEventHandler("doc:open", function(loc)
    print("opening!")
    mainMenu:Visible(not mainMenu:Visible())
    closest_location = loc
end)

RegisterNetEvent("doc:uniformLoaded")
AddEventHandler("doc:uniformLoaded", function(uniform)

  if uniform then

    Citizen.CreateThread(function()
        for key, value in pairs(uniform["components"]) do
            SetPedComponentVariation(PlayerPedId(), tonumber(key), value, uniform["componentstexture"][key], 0)
        end
        for key, value in pairs(uniform["props"]) do
            SetPedPropIndex(PlayerPedId(), tonumber(key), value, uniform["propstexture"][key], true)
        end
      -------------------------
      -- give health / armor --
      -------------------------
      SetEntityHealth(GetPlayerPed(-1), 200)
      SetPedArmour(GetPlayerPed(-1), 100)
    end)

  else
    exports["globals"]:notify("No uniform saved!")
  end
end)

RegisterNetEvent("doc:close")
AddEventHandler("doc:close", function()
    _menuPool:CloseAllMenus()
end)

----------------------
-- VEHICLE SPAWNING --
----------------------
function addVehicles(id)
  for i = 1, #vehicles do
    TriggerEvent("menu:addModuleItem", id, vehicles[i].name, nil, false, function(id, state)
      SpawnVehicle(vehicles[i].hash)
    end)
  end
end

function SpawnVehicle(model)
  Citizen.CreateThread(function()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(100)
    end

    local veh = CreateVehicle(model, x + 2.5, y + 2.5, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleExplodesOnHighExplosionDamage(veh, false)
    SetVehicleLivery(veh, 2) -- DOC SKIN
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)

    -- give key to owner
    local vehicle_key = {
      name = "Key -- " .. GetVehicleNumberPlateText(veh),
      quantity = 1,
      type = "key",
      owner = "GOVT",
      make = "GOVT",
      model = "GOVT",
      plate = GetVehicleNumberPlateText(veh)
    }
		TriggerServerEvent("garage:giveKey", vehicle_key)
  end)
end

---------------------
-- WEAPON SPAWNING --
---------------------
RegisterNetEvent("doc:equipWeapon")
AddEventHandler("doc:equipWeapon", function(weapon)
    if type(weapon.hash) ~= "number" then
        weapon.hash = GetHashKey(weapon.hash)
    end
    GiveWeaponToPed(GetPlayerPed(-1), weapon.hash, 1000, 0, false)
    exports.globals:notify("Equipped: " .. weapon.name)
end)
