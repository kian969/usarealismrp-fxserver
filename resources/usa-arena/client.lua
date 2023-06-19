local ARENA_COORDS = vector3(-1293.4060058594, -3391.3923339844, 13.940145492554)

local registeredDeath = false

local wasArmed = false

exports.globals:createCulledNonNetworkedPedAtCoords("a_m_y_latino_01", {
    {x = ARENA_COORDS.x, y = ARENA_COORDS.y, z = ARENA_COORDS.z, heading = 59.0}
}, 300.0, "[E] - Arena", 5.0, function()
    lib.registerContext({
		id = 'usa:arena',
		title =  "Welcome to the Arena!",
		options = {
			{           
				title = "Leaderboard",
                description = "Display the leaderboard!",
				event = "arena:leaderboard"
			},
			{           
				title = "Join the arena",
                description = "Get assigned a team and start playing!",
				event = "arena:join"
			},
			{           
				title = "Leave the arena",
                description = "Leave your team",
				event = "arena:leave"
			},
			{           
				title = "Team Info",
                description = "Show current team info",
				event = "arena:teamInfo"
			},
		}
	})
	lib.showContext('usa:arena')
end, 38)

RegisterCommand("arenajoin", function()
	TriggerEvent("arena:join")
end, true)

RegisterNetEvent("arena:join")
AddEventHandler("arena:join", function()
    TriggerServerEvent("arena:join")
	isPlaying = true
	TriggerEvent("arena:setPlayingArenaState", true)
end)

RegisterNetEvent("arena:leave")
AddEventHandler("arena:leave", function()
    TriggerServerEvent("arena:leave")
	exports.globals:notify("Left arena", "^3INFO: ^0You have left the arena")
	isPlaying = false
	TriggerEvent("arena:setPlayingArenaState", false)

end)

RegisterNetEvent("arena:leaderboard")
AddEventHandler("arena:leaderboard", function()
	TriggerServerEvent("arena:leaderboard")
end)

RegisterNetEvent("arena:teamInfo")
AddEventHandler("arena:teamInfo", function()
    TriggerServerEvent("arena:teamInfo")
	isPlaying = true
end)

RegisterNetEvent("arena:gameStarting")
AddEventHandler("arena:gameStarting", function()
	wasArmed = IsPedArmed(PlayerPedId(), 1 | 2 | 4)
end)

RegisterNetEvent("arena:gameStarted")
AddEventHandler("arena:gameStarted", function()
	if wasArmed then
		TriggerServerEvent("arena:equipLastWeapon")
	end
end)

RegisterNetEvent("arena:gameEnded")
AddEventHandler("arena:gameEnded", function()
	wasArmed = false
end)

CreateThread(function()
	while true do
		if isPlaying then
			local me = PlayerPedId()
			if IsEntityDead(me) and not registeredDeath then
				registeredDeath = true
				local killerEntity = GetPedSourceOfDeath(me)
				local killerPlayerServerId = nil
				for id = 0, 255 do
					if NetworkIsPlayerActive(id) then
						if GetPlayerPed(id) == killerEntity then
							killerPlayerServerId = GetPlayerServerId(id)
						end
					end
				end
				TriggerServerEvent("arena:died", killerPlayerServerId)
			elseif registeredDeath and not IsEntityDead(me) then
				registeredDeath = false
			end
		end
		Wait(0)
	end
end)

--[[
CreateThread(function()
	while true do
		if isPlaying then
			local mycoords = GetEntityCoords(PlayerPedId())
			local dist = #(mycoords - ARENA_COORDS)
			if dist >= 125 then
				TriggerEvent("arena:leave")
			end
		end
		Wait(1)
	end
end)
--]]

local arenaPolyZone = PolyZone:Create({
    vector2(-1302.663, -3409.087),
	vector2(-1271.66, -3361.457),
	vector2(-1240.776, -3379.063),
	vector2(-1269.805, -3428.914)
}, {
    name = "arenaPolyZone",
    debugGrid = false,
    maxZ = 115.61,
    gridDivisions = 45
})

arenaPolyZone:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
    if not isPointInside and isPlaying then
		TriggerEvent("arena:leave")
	end
end)