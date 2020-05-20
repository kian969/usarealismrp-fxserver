local has_tank = nil

RegisterServerEvent('scuba:checkItems')
AddEventHandler('scuba:checkItems', function()
    local char = exports["usa-characters"]:GetCharacter(source)

    if char.hasItem('Air Tank') then
        TriggerClientEvent('scuba:useAirTank', source)
    end
end)

RegisterServerEvent('scuba:removeTank')
AddEventHandler('scuba:removeTank', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    if char.hasItem("Air Tank") then
        char.removeItem("Air Tank")
    end
end)