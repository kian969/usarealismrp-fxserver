local MINIMUM_MINUTES_BETWEEN_REASONABLE_PAY = 2
local MAX_ROUTE_OR_PICKUP_DIST = 15294

local lastPayTimes = {}

RegisterServerEvent("taxiJob:payDriver")
AddEventHandler("taxiJob:payDriver", function(routeDist, pickupDist)
	local src = source
	if lastPayTimes[src] then
		if os.difftime(os.time(), lastPayTimes[src]) < MINIMUM_MINUTES_BETWEEN_REASONABLE_PAY * 60 then
			print("sus uber pay")
			return
		end
	end
	lastPayTimes[src] = os.time()
	if routeDist >= MAX_ROUTE_OR_PICKUP_DIST or pickupDist >= MAX_ROUTE_OR_PICKUP_DIST then
		print("sus route or pickup dist")
		return
	end
	local isClientNearDropOff = TriggerClientCallback {
		source = src,
		eventName = "uber:isNearDropOff",
		args = {}
	}
	if not isClientNearDropOff then
		print("not near drop off!")
		return
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