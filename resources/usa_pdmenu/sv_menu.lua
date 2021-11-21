local LEO_VEHICLES = {"valor16fpui", "valor20fpiu", "valorcvpi", "valor15f150", "valorfpis", "valorgmc", "valor18tahoe", "pdcvpi", "pdtau", "pdchgr", "pdcharger", "pdexp", "pdfpiu", "sotruck", "hptahoe", "sheriff2", "bwtrail", "policeb", "1200RT", "pbike", "chgr","fbi", "fbi2", "police4", "mustang19", "npolstang", "npolchal", "npolvette", "riot", "bearcatrb", "policet", "pbus"}

local JOB_VEHICLES = {
	["sheriff"] = LEO_VEHICLES,
	["corrections"] = LEO_VEHICLES,
	["ems"] = {"ambulance", "paraexp", "firetruk", "lguard2", "blazer"},
	["doctor"] = {"paraexp"}
}

RegisterServerEvent("pdmenu:checkWhitelistForGarage")
AddEventHandler("pdmenu:checkWhitelistForGarage", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job], user_job)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)
