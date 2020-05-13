local ITEMS = {
    ['Stolen Goods'] = {
        {name = 'Hotwiring Kit', value = 125},
        {name = 'LSD Vial', value = 500},
        {name = 'Everclear Vodka (90%)', value = 18},
        {name = 'Lockpick', value = 65},
        {name = 'First Aid Kit', value = 40},
        {name = 'Pistol', value = 300},
        {name = 'Razor Blade', value = 500},
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