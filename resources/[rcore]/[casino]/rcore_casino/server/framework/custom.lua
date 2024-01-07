if Framework.Active == 4 then
    ITEM_TYPES = {
        casino_beer = "drink",
        casino_coffee = "drink",
        casino_coke = "drink",
        casino_sprite = "drink",
        casino_luckypotion = "drink",
        casino_psqs = "food",
        casino_ego_chaser = "food",
        casino_sandwitch = "food",
        casino_donut = "food",
        casino_diamondchamp = "alcohol",
        casino_goldchamp = "alcohol",
        casino_silverchamp = "alcohol",
        casino_macbethshot = "alcohol",
        casino_richardshot = "alcohol",
        casino_vodka = "alcohol"
    }

    ESX = {}

    ESX.RegisterUsableItem = function(itemName, callBack)

    end

    ESX.GetPlayerFromId = function(source)
        local char = exports["usa-characters"]:GetCharacter(source)

        if not char then return nil end

        local xPlayer = {}
        ---------
        xPlayer.identifier = char.get("_id")
        ---------
        xPlayer.license = char.get("created").ownerIdentifier
        ---------
        xPlayer.job = {
            name = char.get("job"),
            label = char.get("job"),
            grade = {
                name = char.get("job"),
                level = 2 -- todo: implement diff casino job grade levels
            }
        }
        ---------
        xPlayer.getGroup = function()
            -- gets player ground (admin, mod, player...)
            local user = exports["essentialmode"]:getPlayerFromId(source)
            return user.getGroup()
        end
        ---------
        xPlayer.getJob = function()
            return {
                grade = 2, -- todo
                grade_name = char.get("job"),
                name = char.get("job")
            }
        end
        ---------
        xPlayer.getName = function()
            return char.getName()
        end
        ---------
        xPlayer.getTotalAmount = function(item) -- ! need to test
            print("item: " .. json.encode(item))
            local itemData = char.getItem(item)
            if itemData then
                return itemData.quantity
            else
                return 0
            end
        end
        ---------
        xPlayer.addInventoryItem = function(item, count)
            print("adding inv item: " .. json.encode(item))
            local actualItem = {
                name = item,
                quantity = count,
                weight = 1.0
            }
            actualItem.type = ITEM_TYPES[item]
            if item == "casino_chips" then
                actualItem.weight = 0.0
            end
            char.giveItem(actualItem, count)
        end
        ---------
        xPlayer.removeInventoryItem = function(item, count)
             char.removeItem(item, count)
        end
        ---------
        xPlayer.getMoney = function()
            return char.get("money")
        end
        ---------
        xPlayer.addMoney = function(money)
           char.giveMoney(money)
        end
        ---------
        xPlayer.addAccountMoney = function(type, money)
            if type == "money" then
                char.giveMoney(money)
            else
                char.giveBank(money)
            end
        end
        ---------
        xPlayer.getAccount = function(type)
            if type == "money" then
                return char.get("money")
            else 
                return char.get("bank")
            end
        end
        ---------
        xPlayer.removeAccountMoney = function(type, money)
            if type == "money" then
                return char.removeMoney(money)
            else 
                return char.removeBank(money)
            end
        end
        ---------
        xPlayer.removeMoney = function(money)
            char.removeMoney(money)
        end
        ---------
        xPlayer.getInventoryItem = function(itemName)
            print("trying to get inv item: " .. itemName)
            local item = char.getItem(itemName)
            if item then
                local ItemInfo = {
                    name = item.name,
                    count = item.quantity,
                    label = item.name,
                    weight = item.weight,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
                return ItemInfo
            else
                return nil
            end
        end
        ---------
        return xPlayer
    end
end