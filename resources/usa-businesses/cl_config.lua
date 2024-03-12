POLICE_NEEDED = 2
policeNeededForBonus = 3
robberyCooldown = 2100

LEASE_PERIOD_DAYS = 14
DEFAULT_PURCHASE_PERCENT_REWARD = 0.20

KEYS = {
	K = 311,
	E = 38
}

BASE_ROB_DURATION = 60000

BUSINESSES = {}

RegisterNetEvent("businesses:load")
AddEventHandler("businesses:load", function(data)
	print("loaded businesses from server!!")
	BUSINESSES = data
end)

TriggerServerEvent("businesses:load")