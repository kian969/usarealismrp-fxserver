-- todo: replace securityToken stuff with checks to make sure 1) player was in a taxi driver seat, 2) last trigger was a reasonable time ago, and 3) distance is reasonable
RegisterServerEvent("taxiJob:payDriver")
AddEventHandler("taxiJob:payDriver", function(routeDist, pickupDist, securityToken)
	local src = source
	if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), src, securityToken) then
		return false
	end
	local char = exports["usa-characters"]:GetCharacter(src)
	if char.get("job") == "uber" then
		local amountRewarded = math.ceil((0.62 * routeDist) + (0.22 * pickupDist))
		char.giveBank(amountRewarded)
		TriggerClientEvent('usa:notify', src, 'Request completed, you have received: ~g~$'..exports.globals:comma_value(amountRewarded), '^3INFO: ^0Request completed, you have received: ^2$'..exports.globals:comma_value(amountRewarded))
		local prev = exports.essentialmode:getDocument("uber-driver-stats", char.get("_id"))
		if not prev then
			prev = 0
		else
			prev = prev.ridesCompleted
		end
		local new = prev + 1
		exports.essentialmode:updateDocument("uber-driver-stats", char.get("_id"), { name = char.getName(), ridesCompleted = new }, true)
	else
		print("TAXI: SKETCHY TAXI payDriver event trigged by source " .. src .. "!!")
	end
end)

RegisterServerEvent("taxiJob:setJob")
AddEventHandler("taxiJob:setJob", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get("job") == "uber" then
		TriggerClientEvent("taxiJob:offDuty", source)
		char.set("job", "civ")
	else
		local money = char.get("money")
		local drivers_license = char.getItem("Driver's License")
		if drivers_license then
			if drivers_license.status == "valid" then
				char.set("job", "uber")
				TriggerClientEvent("taxiJob:onDuty", source)
				return
			else
				TriggerClientEvent("usa:notify", source, "Your driver's license is ~y~suspended~s~!")
				return
			end
		else
			TriggerClientEvent("usa:notify", source, "You do not have a driver's license!")
			return
		end
	end
end)

RegisterServerEvent("uber:fetchLeaderboard")
AddEventHandler("uber:fetchLeaderboard", function()
	local src = source
	local allDocs = exports.essentialmode:getAllDocuments("uber-driver-stats")
	table.sort(allDocs, function(a, b)
		return a.ridesCompleted > b.ridesCompleted
	end)
	TriggerClientEvent("usa:notify", src, false, "^3INFO: ^0Top 10 Uber Drivers:")
	for i = 1, 10 do
		if allDocs[i] then
			TriggerClientEvent("usa:notify", src, false, allDocs[i].name .. ": " .. allDocs[i].ridesCompleted)
		end
	end
end)

TriggerEvent('es:addJobCommand', 'togglerequests', {'uber'}, function(source, args, char)
	TriggerClientEvent("taxi:toggleNPCRequests", source)
end, {
	help = "Toggle receiving local ride requests"
})

exports["globals"]:PerformDBCheck("usa_taxijob", "uber-driver-stats", CheckBusinessLeases)