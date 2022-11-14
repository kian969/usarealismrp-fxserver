AddEventHandler("character:loaded", function(char)
    if not char.get("phoneNumber") then
        char.set("phoneNumber", exports.npwd:generatePhoneNumber())
    end
    exports.npwd:unloadPlayer(char.get("source"))
    exports.npwd:newPlayer({
        source = char.get("source"),
        phoneNumber = char.get("phoneNumber"),
        identifier = char.get("_id"),
        firstname = char.get("name").first,
        lastname = char.get("name").last
    })
end)

exports.npwd:onMessage('911', function(ctx)
    local charPhoneNumber = exports["usa-characters"]:GetCharacter(ctx.source).get("phoneNumber")
    local coords = GetEntityCoords(GetPlayerPed(ctx.source))
    TriggerEvent('911:call', coords.x, coords.y, coords.z, "[" .. charPhoneNumber .. "] " .. ctx.data.message, "Call for service")
end)