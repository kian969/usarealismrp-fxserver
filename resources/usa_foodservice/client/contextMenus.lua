local orderTargetPlayerId = 2
local newOrderItems = {}

local NEW_ORDER_MENU = {
    {
        header = "($500) Money Shot Burger",
        context = "Double patty burger",
        event = "bs:addOrderItem",
        args = {
            "Money Shot Burger"
        }
    },
    {
        header = "($375) The Bleeder Burger",
        context = "Single patty burger",
        event = "bs:addOrderItem",
        args = {
            "The Bleeder Burger"
        }
    },
    {
        header = "($375) Torpedo Sandwich",
        context = "Sandwich",
        event = "bs:addOrderItem",
        args = {
            "Torpedo Sandwich"
        }
    },
    {
        header = "($375) Meat Free Burger",
        context = "Plant based burger",
        event = "bs:addOrderItem",
        args = {
            "Meat Free Burger"
        }
    },
    {
        header = "($175) French Fries",
        context = "Crispy french fries",
        event = "bs:addOrderItem",
        args = {
            "French Fries"
        }
    },
    {
        header = "($350) Coca Cola",
        context = "A refreshing beverage",
        event = "bs:addOrderItem",
        args = {
            "Coca Cola"
        }
    },
    {
        header = "Done",
        context = "Register the new order",
        event = "bs:registerNewOrder",
        args = {}
    }
}

target.addPoint("bsMainMenu", "Register", "fas fa-hamburger", vector3(-1195.634, -893.85, 13.88616), 1, function() end, {
    {
        name = 'newOrder',
        label = 'New Order',
        onSelect = function(a, b, entityHandle)
            -- duty check
            if not isClockedIn("burgershot") then
                exports.globals:notify("Must be clocked in")
                return
            end
            -- reset new order state
            resetNewOrderState()
            -- get ID of player order is for
            orderTargetPlayerId = lib.inputDialog('Target Person SSN', {'SSN'})
            if not orderTargetPlayerId then return end
            orderTargetPlayerId = orderTargetPlayerId[1]
            -- select items to add to order
            TriggerEvent('nh-context:createMenu', NEW_ORDER_MENU)
        end
    },
    {
        name = 'retrieveVehicle',
        label = 'Retrieve Delivery Vehicle',
        onSelect = function(a, b, entityHandle)
            if not isClockedIn("burgershot") then
                exports.globals:notify("Must be clocked in")
                return
            end
            RequestModel(`nspeedo`)
            while not HasModelLoaded(`nspeedo`) do
                Wait(1)
            end
            local deliveryVehicle = CreateVehicle(`nspeedo`, -1204.4656982422, -901.98754882812, 13.473096847534, 32.7, true)
            SetVehicleLivery(deliveryVehicle, 1)
            local plate = GetVehicleNumberPlateText(deliveryVehicle)
            TriggerServerEvent("garage:giveKeyWithPlate", false, plate)
            TriggerEvent("usa:notify", "Retrieved", "^3INFO: ^0Delivery vehicle retrieved!")
        end
    },
    {
        name = 'toggleClockIn',
        label = 'Clock in/out',
        onSelect = function(a, b, entityHandle)
            TriggerServerEvent("bs:toggleDuty")
        end
    },
})

target.addPoint("bsOrdersMenu", "Orders", "fas fa-hamburger", vector3(-1195.372, -897.1624, 14.808616), 1, function() end, {
    {
        name = 'viewOrders',
        label = 'View Orders',
        onSelect = function(a, b, entityHandle)
            local currentOrders = TriggerServerCallback {
                eventName = "bs:getOrders",
                args = {}
            }
            local ordersMenu = {
                {
                    header = "Select an order to make:"
                }
            }
            for number, items in pairs(currentOrders) do
                local orderContentsStr = ""
                for i = 1, #items do
                    orderContentsStr = orderContentsStr .. "(" .. items[i].quantity .. ") " .. items[i].itemName .. ", "
                end
                table.insert(ordersMenu, {
                    header = "Order #" .. number,
                    context = orderContentsStr,
                    event = "bs:prepareMeal",
                    args = {
                        number
                    }
                })
            end
            TriggerEvent('nh-context:createMenu', ordersMenu)
        end
    },
})

target.addPoint("bsCounterMenu", "Counter", "fas fa-hamburger", vector3(-1192.118, -893.2803, 13.88616), 1, function() end, {
    {
        name = 'claimOrder',
        label = 'Claim Order',
        onSelect = function(a, b, entityHandle)
            if isClockedIn("burgershot") then
                local orderNumber = lib.inputDialog('Retrieve Order', {'Number'})
                if not orderNumber then return end
                orderNumber = orderNumber[1]
                TriggerServerEvent("bs:claimOrder", orderNumber)
            else
                TriggerServerEvent("bs:claimOrder")
            end
        end
    },
})

function resetNewOrderState()
    orderTargetPlayerId = nil
    newOrderItems = {}
end

function isClockedIn(job)
    local charInfo = TriggerServerCallback {
        eventName = "usa-characters:getCharInfo",
        args = {}
    }
    return charInfo.job == job
end

RegisterNetEvent("bs:addOrderItem", function(itemName)
    -- get quantity
    local quantity = lib.inputDialog('Quantity of ' .. itemName, {'Quantity'})
    if not quantity then return end
    quantity = quantity[1]
    -- add to order
    table.insert(newOrderItems, { itemName = itemName, quantity = quantity })
    -- re open new order menu
    TriggerEvent('nh-context:createMenu', NEW_ORDER_MENU)
end)

RegisterNetEvent("bs:registerNewOrder", function()
    TriggerServerEvent("bs:registerNewOrder", orderTargetPlayerId, newOrderItems)
end)

RegisterNetEvent("bs:prepareMeal", function(number)
    local currentOrders = TriggerServerCallback {
        eventName = "bs:getOrders",
        args = {}
    }
    local orderItems = currentOrders[number]
    local minutesToCook = 0
    for i = 1, #orderItems do
        minutesToCook = minutesToCook + (1.2 * orderItems[i].quantity)
    end
    print("total cook time: " .. minutesToCook)
    if lib.progressBar({
        duration = minutesToCook * 60 * 1000,
        label = 'Preparing',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = "friends@",
            clip = "pickupwait",
            flag = 11
        },
    }) then
        TriggerServerEvent("bs:mealPrepared", number)
    end
end)

RegisterNetEvent("bs:toggleUniform", function(putOn)
    if putOn then
        local me = PlayerPedId()
        if IsPedModel(me,"mp_f_freemode_01") then
            SetPedComponentVariation(me, 3, 9, 0, 0) -- arms/hands
            SetPedComponentVariation(me, 11, 420, 2, 2) -- torso
            SetPedComponentVariation(me, 8, 7, 0, 2) -- torso 1
            SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
            --SetPedComponentVariation(me, 7, 34,1, 2) -- ties
            SetPedComponentVariation(me, 4, 31, 2, 2) -- legs
            --SetPedComponentVariation(me, 6, 58, 1, 2) -- feet
            --SetPedPropIndex(me, 0, 1, math.random(1, 7), true) -- add headet on head (need to find right prop)
        elseif IsPedModel(me,"mp_m_freemode_01") then -- male
            SetPedComponentVariation(me, 3, 6, 0, 0) -- arms/hands
            SetPedComponentVariation(me, 11, 406, 1, 2) -- torso
            SetPedComponentVariation(me, 8, 21, 4, 2) -- accessories
            SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
            --SetPedComponentVariation(me, 7, 9,11, 2) -- ties
            SetPedComponentVariation(me, 4, 28, 1, 2) -- legs
            --SetPedComponentVariation(me, 6, 10, 0, 0) -- feet
            --SetPedPropIndex(me, 0, 0, math.random(1, 7), true) -- add headet on head(need to find right prop)
        end
    else
        TriggerServerEvent("usa:loadPlayerComponents")
    end
end)

RegisterClientCallback {
    eventName = "bs:confirmOrder",
    eventCallback = function(price)
        local input = lib.inputDialog("Confirm order for $" .. exports.globals:comma_value(price) .. "?", {
            {type = "checkbox", label = "Yes, place order"}
        })
        if not input then return end
        return input[1]
    end
}