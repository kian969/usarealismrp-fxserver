TriggerEvent('es:addCommand', 'selfie', function(source, args, char)
	if char.hasItem("Cell Phone") then
        TriggerClientEvent("camera:selfie", source)
    else
        TriggerClientEvent("usa:notify", source, "You need a cell phone to do that!")
    end
end, {help = "Go into selfie camera mode!"})