local ITEMS = {
    ['Stolen Goods'] = {
        {name = 'Hotwiring Kit', value = 125},
        {name = 'LSD Vial', value = 500},
        {name = 'Everclear Vodka (90%)', value = 18},
        {name = 'Lockpick', value = 65},
        {name = 'First Aid Kit', value = 40},
        {name = 'Pistol', value = 300},
        {name = 'Razor Blade', value = 30},
        {name = 'Switchblade', value = 1500},
        {name = 'Condoms', value = 5},
        {name = 'KY Intense Gel', value = 10},
        {name = 'Viagra', value = 15},
        {name = 'Sturdy Rope', value = 50},
        {name = 'Bag', value = 50},
        {name = 'Ludde\'s Lube', value = 10},
        {name = 'Fluffy Handcuffs', value = 20},
        {name = 'Vibrator', value = 50},
        {name = 'Sam Smith\'s Strapon', value = 80},
    }
}

RegisterServerEvent('pawn:loadItems')
AddEventHandler('pawn:loadItems', function()
    TriggerClientEvent('pawn:loadItems', source, ITEMS)
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