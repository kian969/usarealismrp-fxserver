local newOrders = {}
local preparedOrders = {}

RegisterServerEvent("bs:toggleDuty", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    -- check if added as employee
    if not isAnEmployee("Burgershot", char.get("_id")) then
        TriggerClientEvent("usa:notify", source, "You don't work here! Talk to the owners to apply.")
        return
    end
    -- toggle clock on if so
    if char.get("job") ~= "burgershot" then
        char.set("job", "burgershot")
        TriggerClientEvent("usa:notify", source, "You have clocked in!")
        TriggerClientEvent("bs:toggleUniform", source, true)
    else
        char.set("job", "civ")
        TriggerClientEvent("usa:notify", source, "You have clocked out!")
        TriggerClientEvent("bs:toggleUniform", source, false)
    end
end)

RegisterServerEvent("bs:registerNewOrder", function(orderNumber, orderDetails)
    local src = source
    -- target customer ID check
    if not GetPlayerName(orderNumber) then
        TriggerClientEvent("usa:notify", src, "Invalid customer SSN", "^3INFO: ^0Target customer SSN not valid, try again")
        return
    end
    -- check for sufficient money and take from customer
    local orderTotal = 0
    for i = 1, #orderDetails do
        orderTotal = orderTotal + CONFIG.BURGERSHOT.ITEMS[orderDetails[i].itemName].PRICE * orderDetails[i].quantity
    end
    local acceptedOrder = TriggerClientCallback {
        eventName = "bs:confirmOrder",
        source = tonumber(orderNumber),
        args = {orderTotal}
    }
    if not acceptedOrder then
        TriggerClientEvent("usa:notify", src, "Person denied order")
        return
    end
    local customer = exports["usa-characters"]:GetCharacter(tonumber(orderNumber))
    if customer.get("bank") < orderTotal then
        TriggerClientEvent("usa:notify", src, "Insufficent funds", "^3INFO: ^0Not enough money! Need: $" .. exports.globals:comma_value(orderTotal))
        return
    end
    customer.removeBank(orderTotal, "Burgershot")
    -- give money to business
    TriggerEvent("properties-og:depositCash", "Burgershot", orderTotal)
    -- record new order
    newOrders[tostring(orderNumber)] = orderDetails
    local orderContentsStr = ""
    for i = 1, #orderDetails do
        orderContentsStr = orderContentsStr .. "(" .. orderDetails[i].quantity .. ") " .. orderDetails[i].itemName .. ", "
    end
    exports.globals:notifyPlayersWithJob("burgershot", "^3INFO: ^0New order! (#" .. orderNumber ..") " .. orderContentsStr)
end)

RegisterServerEvent("bs:mealPrepared", function(orderNumber)
    local orderDetails = newOrders[tostring(orderNumber)]
    local orderTotal = 0
    for i = 1, #orderDetails do
        orderTotal = orderTotal + CONFIG.BURGERSHOT.ITEMS[orderDetails[i].itemName].PRICE
    end
    -- put on counter
    preparedOrders[tostring(orderNumber)] = newOrders[tostring(orderNumber)]
    -- remove from current orders
    newOrders[tostring(orderNumber)] = nil
    -- notify customer order is ready
    TriggerClientEvent("usa:notify", orderNumber, "Order ready!", "^3INFO: ^0Your burgershot order is ready! Pick it up from the counter or wait for your delivery.")
end)

RegisterServerEvent("bs:claimOrder", function(desiredOrderNumber)
    local orderNumber = tostring(source)
    if desiredOrderNumber then
        orderNumber = desiredOrderNumber
    end
    if newOrders[orderNumber] then
        TriggerClientEvent("usa:notify", source, "Not ready", "^3INFO: ^0Your order is still being prepared")
        return
    end
    if not preparedOrders[orderNumber] and not newOrders[orderNumber] then
        TriggerClientEvent("usa:notify", source, "No order", "^3INFO: ^0You have not ordered anything")
        return
    end
    if preparedOrders[orderNumber] then
        -- drop order items for pickup
        local items = preparedOrders[orderNumber]
        for i = 1, #items do
            local itemToDrop = exports.usa_rp2:getItem(items[i].itemName)
            itemToDrop.quantity = tonumber(items[i].quantity)
            itemToDrop.coords = GetEntityCoords(GetPlayerPed(source))
            itemToDrop.playerMade = true
            TriggerEvent("interaction:addDroppedItem", itemToDrop)
        end
        -- remove order
        preparedOrders[orderNumber] = nil
    end
end)

RegisterServerCallback {
    eventName = "bs:getOrders",
    eventCallback = function()
        return newOrders
    end
}

function isAnEmployee(businessName, identifier)
    local ownedProperties = exports["usa-properties-og"]:GetOwnedProperties(identifier, true)
    for i = 1, #ownedProperties do
        if ownedProperties[i].name == businessName then
            return true
        end
    end
    return false
end