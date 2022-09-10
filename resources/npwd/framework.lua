AddEventHandler("character:loaded", function(char)
    exports.npwd:newPlayer({
        source = char.get("source"),
        phoneNumber = "949351544" .. tostring(math.random(0, 9)),
        identifier = char.get("_id"),
        firstname = char.get("name").first,
        lastname = char.get("name").last
    })
end)

-- todo: call unload player event when /swap is used