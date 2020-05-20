local AIR_TANK_CONSUMPTION = math.random(30, 120)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        --if IsControlJustPressed(0, 86) then
        if IsPedSwimmingUnderWater(player) == 1 then
            TriggerServerEvent('scuba:checkItems')
        end
        --end
    end
end)

RegisterNetEvent('scuba:useAirTank')
AddEventHandler('scuba:useAirTank', function()
    local player = PlayerPedId()
    SetPedScubaGearVariation(player)
    SetPedMaxTimeUnderwater(player, 100.0 * 2)  -- 10 mins air supply
    local oxygenRemaining = GetPlayerUnderwaterTimeRemaining(PlayerId())
    if oxygenRemaining <= AIR_TANK_CONSUMPTION then
        TriggerServerEvent('scuba:removeTank')
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local oxygenRemaining = GetPlayerUnderwaterTimeRemaining(PlayerId())

        print(oxygenRemaining)
        if oxygenRemaining == 100 then
            exports.globals:notify('Oxygen tank is at 50%')
        elseif oxygenRemaining == 50 then
            exports.globals.notify('Oxygen Running low, return to surface')
        end
    end
end)
