local ITEMS = {}
TriggerServerEvent('pawn:loadItems')

local NPC = 'a_m_m_ktown_01'
local NPC_COORDS = {448.4, -803.37, 27.8}
local createdMenus = {}
local KEY_E = 38

local openingHour = math.random(8, 10)

_menuPool = NativeUI.CreatePool()
pawnMenu = NativeUI.CreateMenu("Stolen Goods Menu", "~b~Please select an item you would like to sell!", 0, 320)
table.insert(createdMenus, { menu = pawnMenu, category = "Stolen Goods"})

for i = 1, #createdMenus do
    _menuPool:Add(createdMenus[i].menu)
end

RegisterNetEvent('pawn:loadItems')
AddEventHandler('pawn:loadItems', function(items)
    ITEMS = items
    for i = 1, #createdMenus do
        CreateMenu(createdMenus[i].menu, createdMenus[i].category)
    end
    _menuPool:RefreshIndex()
end)

-- Spawns NPC
local NPCHandle = nil
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local x,y,z = table.unpack(NPC_COORDS)
        if Vdist(playerCoords, x, y, z) < 40 then
            if not NPCHandle then
                RequestModel(GetHashKey(NPC))
                while not HasModelLoaded(NPC) do
                    RequestModel(NPC)
                    Wait(1)
                end
                NPCHandle = CreatePed(0, NPC, x, y, z, 0.1, false, false) -- Distance culling
                SetEntityCanBeDamaged(NPCHandle, false)
                SetPedCanRagdollFromPlayerImpact(NPCHandle, false)
                SetBlockingOfNonTemporaryEvents(NPCHandle, true)
                SetPedFleeAttributes(NPCHandle, 0, 0)
                SetPedCombatAttributes(NPCHandle, 17, 1)
            end
        else
            if NPCHandle then
                DeletePed(NPCHandle)
                NPCHandle = nil
            end
        end
    end
end)

-- Interact with NPC and open the menu
Citizen.CreateThread(function()
    while true do
        _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        _menuPool:ProcessMenus()
        local x,y,z = table.unpack(NPC_COORDS)
        if nearMarker(x,y,z) then
            DrawText3D(x,y,z, 8, '[E] - Sell Goods')
            if IsControlJustPressed(0, KEY_E) then
                if _menuPool:IsAnyMenuOpen() then
                    _menuPool:CloseAllMenus()
                end
                for i = 1, #createdMenus do
                    createdMenus[i].menu:Visible(true)
                end
            end
        else
            _menuPool:CloseAllMenus()
        end
        Wait(0)
    end
end)


function nearMarker(x, y, z)
    local myCoords = GetEntityCoords(PlayerPedId(), false)
    return GetDistanceBetweenCoords(x, y, z, myCoords.x, myCoords.y, myCoords.z, true) < 3
end

function DrawText3D(x, y, z, distance, text)
    if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 470
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end

function CreateMenu(menu, category)
    for i = 1, #ITEMS[category] do
        local stolenItem = ITEMS[category][i]
        local item = NativeUI.CreateItem(stolenItem.name, "Sell For $" .. exports["globals"]:comma_value(stolenItem.value))
        item.Activated = function(parentmenu, selected)
            TriggerServerEvent('pawn:sellItem', stolenItem)
        end
        menu:AddItem(item)
    end
end