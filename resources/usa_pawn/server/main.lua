RegisterServerEvent('pawn:loadItems')
AddEventHandler('pawn:loadItems', function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local user_items = {}
    local inventory = char.get("inventory")
    for i = 0, (inventory.MAX_CAPACITY - 1) do
        if inventory.items[tostring(i)] then
            local item = inventory.items[tostring(i)]
            if item.type ~= "license" and item.type ~= "key" and item.name ~= "Cell Phone" then
                table.insert(user_items, inventory.items[tostring(i)])
            end
        end
    end
    TriggerClientEvent('pawn:loadItems', source, user_items)
end)

RegisterServerEvent('pawn:sellItem')
AddEventHandler('pawn:sellItem', function(item)
    local char = exports['usa-characters']:GetCharacter(source)
    if char.hasItem(item.name) then
        char.removeItem(item, 1)
        char.giveMoney(item.value)
        TriggerClientEvent('usa:notify', source, 'You have sold 1 ' .. item.name .. ' for $' .. item.value)
    else
        TriggerClientEvent('usa:notify', source, 'You do not have this item to sell!')
    end
end)