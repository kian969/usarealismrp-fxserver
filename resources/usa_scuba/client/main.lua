Citizen.CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        --if IsControlJustPressed(0, 86) then
            SetPedScubaGearVariation(player)
            SetPedMaxTimeUnderwater(player, 360.0)
            if IsPedSwimmingUnderWater(player) == 1 then
                TriggerServerEvent('scuba:checkItems')
            end
        --end
    end
end)

RegisterNetEvent('scuba:useAirTank')
AddEventHandler('scuba:useAirTank', function()
    local test = GetPlayerUnderwaterTimeRemaining(PlayerId())
    exports.globals:notify(test)
end)
