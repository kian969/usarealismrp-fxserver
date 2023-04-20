CreateThread(function()
    if Config.Framework ~= "standalone" then
        return
    end

    --- @param source number
    --- @return string | nil
    function GetIdentifier(source)
        print("inside getIdentifier for phone")
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.get("_id")
    end

    ---Check if a player has a phone with a specific number
    ---@param source any
    ---@param number string
    ---@return boolean
    function HasPhoneItem(source, number)
        if not Config.Item.Require then
            return true
        end
        local char = exports["usa-characters"]:GetCharacter(source)
        print("seeing if person has phone")
        return char.hasItem("Cell Phone")
    end

    ---Get a player's character name
    ---@param source any
    ---@return string # Firstname
    ---@return string # Lastname
    function GetCharacterName(source)
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.getName()
    end

    ---Get an array of player sources with a specific job
    ---@param job string
    ---@return table # Player sources
    function GetEmployees(job)
        local ret = {}
        local waiting = true
        exports["usa-characters"]:GetCharacters(function(chars)
            for i = 1, #chars do
                if chars[i].get("job") == job then
                    table.insert(ret, chars[i].get("source"))
                end
            end
            waiting = false
        end)
        while waiting do
            Wait(1)
        end
        return ret
    end

    ---Get the bank balance of a player
    ---@param source any
    ---@return integer
    function GetBalance(source)
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.get("bank")
    end

    ---Add money to a player's bank account
    ---@param source any
    ---@param amount integer
    ---@return boolean # Success
    function AddMoney(source, amount)
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.addBank(amount)
    end

    ---Remove money from a player's bank account
    ---@param source any
    ---@param amount integer
    ---@return boolean # Success
    function RemoveMoney(source, amount)
        local char = exports["usa-characters"]:GetCharacter(source)
        return char.removeBank(amount)
    end

    ---Send a message to a player
    ---@param source number
    ---@param message string
    function Notify(source, message)
        TriggerClientEvent("chat:addMessage", source, {
            color = { 255, 255, 255 },
            multiline = true,
            args = { "Phone", message }
        })
        --TriggerClientEvent("usa:notify", source, false, message)
    end

    -- todo:

    -- GARAGE APP
    function GetPlayerVehicles(source, cb)
        cb({})
    end

    function GetVehicle(source, cb, plate)
        cb(false)
    end

    function IsAdmin(source)
        return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1
    end

    -- COMPANIES APP
    function GetJob(source)
        return "unemployed"
    end

    function RefreshCompanies()
        return {}
    end
end)
