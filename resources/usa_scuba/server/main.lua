local has_tank = nil

RegisterServerEvent('scuba:checkItems')
AddEventHandler('scuba:checkItems', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem('Air Tank') then
        TriggerClientEvent('scuba:useAirTank')
    end
end)