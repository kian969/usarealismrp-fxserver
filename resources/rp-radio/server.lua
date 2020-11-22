
--local radioItem = { name = "Radio", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "prop_cs_hand_radio", blockedInPrison = true}
--exports["usa_stores"]:AddGeneralStoreItem("Misc", radioItem)

RegisterServerEvent("rp-radio:checkForRadioItem")
AddEventHandler("rp-radio:checkForRadioItem", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local civRadio = char.hasItem("Radio")
    local policeRadio = char.hasItem("Police Radio")
    if policeRadio then
        TriggerClientEvent("Radio.Set", source, true, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13})
    elseif civRadio then
        TriggerClientEvent("Radio.Set", source, true, {})
    else
        print("had no radio item!")
        TriggerClientEvent("Radio.Set", source, false, {})
        TriggerClientEvent("usa:notify", source, "You have no radio!")
    end
end)