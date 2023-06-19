-- todo: noise when winning the round

local currentGame = {
    startTime = nil,
    team1 = {},
    team2 = {},
    queue = {}
}

local ARENA = {
    name = "Hangar",
    team1Start = vector3(-1285.034, -3418.448, 13.94016),
    team2Start = vector3(-1257.257, -3373.275, 13.94016)
}

function isOnAnyTeam(source)
    for i = 1, #currentGame.team1 do
        if currentGame.team1[i].source == source then
            return true
        end
    end
    for i = 1, #currentGame.team2 do
        if currentGame.team2[i].source == source then
            return true
        end
    end
    return false
end

RegisterServerEvent("arena:join")
AddEventHandler("arena:join", function()
    if isOnAnyTeam(source) then
        TriggerClientEvent("usa:notify", source, "Already on a team!")
        return
    end
    local char = exports["usa-characters"]:GetCharacter(source)
    local newPlayer = {
        source = source,
        name = char.getName()
    }
    -- add to next game queue
    table.insert(currentGame.queue, newPlayer)
    TriggerClientEvent("usa:notify", source, "Joined the queue", "^3INFO: ^0You joined the arena queue! You will be assigned a random team.")
end)

RegisterServerEvent("arena:leave")
AddEventHandler("arena:leave", function()
    for i = 1, #currentGame.team1 do
        if currentGame.team1[i].source == source then
            notifyPlayers(currentGame.team1[i].name .. " left the arena")
            table.remove(currentGame.team1, i)
            return
        end
    end
    for i = 1, #currentGame.team2 do
        if currentGame.team2[i].source == source then
            notifyPlayers(currentGame.team2[i].name .. " left the arena")
            table.remove(currentGame.team2, i)
            return
        end
    end
end)

RegisterServerEvent("arena:died")
AddEventHandler("arena:died", function(killerSource)
    -- set death info for player
    for i = 1, #currentGame.team1 do
        if currentGame.team1[i].source == source then
            currentGame.team1[i].deathInfo = {
                diedTime = os.time(),
                killedBy = killerSource
            }
            break
        end
    end
    for i = 1, #currentGame.team2 do
        if currentGame.team2[i].source == source then
            currentGame.team2[i].deathInfo = {
                diedTime = os.time(),
                killedBy = killerSource
            }
            break
        end
    end
    -- notify
    local killerChar = exports["usa-characters"]:GetCharacter(killerSource)
    local diedChar = exports["usa-characters"]:GetCharacter(source)
    notifyPlayers(diedChar.getName() .. " was downed by " .. killerChar.getName())
    -- save new K/Ds for players
    updatePlayerStat(source, "deaths", 1)
    updatePlayerStat(killerSource, "kills", 1)
end)

RegisterServerEvent("arena:leaderboard")
AddEventHandler("arena:leaderboard", function()
    local src = source
    local all = exports.essentialmode:getAllDocuments("arena-player-stats")
    for i = 1, #all do
        if all[i].deaths == 0 then
            all[i].deaths = 1
        end
        all[i].kdRatio = exports.globals:round(all[i].kills / all[i].deaths, 2)
    end
    table.sort(all, function(a, b)
        return a.kdRatio > b.kdRatio
    end)
    TriggerClientEvent("usa:notify", src, false, "^3INFO: ^0Top 15 Arena Players:")
    for i = 1, 15 do
        if all[i] then
            local charDoc = exports.essentialmode:getDocument("characters", all[i]._id)
            local name = charDoc.name.first .. " " .. charDoc.name.last
            TriggerClientEvent("usa:notify", src, false, "#" .. i .. " - " .. name .. ": " .. all[i].kdRatio .. " K/D")
        end
    end
end)

RegisterServerEvent("arena:teamInfo")
AddEventHandler("arena:teamInfo", function()
    TriggerClientEvent("usa:notify", source, false, "^3INFO: ^0Current teams:")
    local team1Str = ""
    for i = 1, #currentGame.team1 do
        if i == 1 then
            team1Str = currentGame.team1[i].name
        else
            team1Str = team1Str .. ", " .. currentGame.team1[i].name
        end
    end
    local team2Str = ""
    for i = 1, #currentGame.team2 do
        if i == 1 then
            team2Str = currentGame.team2[i].name
        else
            team2Str = team2Str .. ", " .. currentGame.team2[i].name
        end
    end
    TriggerClientEvent("usa:notify", source, false, "Team 1: " .. team1Str)
    TriggerClientEvent("usa:notify", source, false, "Team 2: " .. team2Str)
    
end)

RegisterServerEvent("arena:equipLastWeapon")
AddEventHandler("arena:equipLastWeapon", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local lastSelectedIndex = char.get("lastSelectedIndex")
    local item = char.getItemByIndex(lastSelectedIndex)
    if item and item.type and item.type == "weapon" then
        TriggerClientEvent("interaction:toggleWeapon", source, item, true)
        char.set("currentlySelectedIndex", lastSelectedIndex)
    end
end)

CreateThread(function()
    local lastCheck = os.time()
    while true do
        if os.difftime(os.time(), lastCheck) >= 5 then
            lastCheck = os.time()
            if not currentGame.startTime then
                -- assign queued players random team
                assignRandomTeams()
                -- start game
                if #currentGame.team1 > 0 and #currentGame.team2 > 0 then
                    print("starting game!")
                    -- notify players
                    notifyPlayers("Next game starting in 30 seconds")
                    -- start delay
                    local startWait = os.time()
                    while os.difftime(os.time(), startWait) <= 30 do
                        Wait(1)
                    end
                    notifyPlayers("Game started!")
                    -- teleport into arena
                    teleportPlayersIntoArena()
                    -- pre game start client stuff
                    triggerPreGameStartClientActions()
                    -- start game
                    currentGame.startTime = os.time()
                end
            else
                -- watch for game ending events
                local team1AliveCount = getAliveCount(currentGame.team1)
                local team2AliveCount = getAliveCount(currentGame.team2)
                if team1AliveCount <= 0 or team2AliveCount <= 0 or #currentGame.team1 <= 0 or #currentGame.team2 <= 0 then
                    print("game ended!")
                    -- notify teams
                    local winningTeam = "undefined"
                    if team1AliveCount <= 0 then
                        winningTeam = "Team 2"
                    else
                        winningTeam = "Team 1"
                    end
                    notifyPlayers(winningTeam .. " won the game! Good game!")
                    -- notify if not enough players
                    if #currentGame.team1 <= 0 or #currentGame.team2 <= 0 then
                        notifyPlayers("Not enough players to start round, waiting for another player (need at least 2)")
                    end
                    -- reset teams for next round
                    resetGame()
                end
            end
        end
        Wait(1)
    end
end)

function notifyPlayers(msg)
    for i = 1, #currentGame.team1 do
        TriggerClientEvent("usa:notify", currentGame.team1[i].source, false, "^3INFO: ^0" .. msg)
    end
    for i = 1, #currentGame.team2 do
        TriggerClientEvent("usa:notify", currentGame.team2[i].source, false, "^3INFO: ^0" .. msg)
    end
end

function teleportPlayersIntoArena()
    for i = 1, #currentGame.team1 do
        TriggerClientEvent("arena:gameStarting", currentGame.team1[i].source)
        SetEntityCoords(GetPlayerPed(currentGame.team1[i].source), ARENA.team1Start.x, ARENA.team1Start.y, ARENA.team1Start.z)
        healAndRevivePlayer(currentGame.team1[i].source)
        print("healed and revived player on team 1 with source: " .. currentGame.team1[i].source)
    end
    for i = 1, #currentGame.team2 do
        TriggerClientEvent("arena:gameStarting", currentGame.team2[i].source)
        SetEntityCoords(GetPlayerPed(currentGame.team2[i].source), ARENA.team2Start.x, ARENA.team2Start.y, ARENA.team2Start.z)
        healAndRevivePlayer(currentGame.team2[i].source)
        print("healed and revived player on team 2 with source: " .. currentGame.team2[i].source)
    end
end

function getAliveCount(team)
    local count = 0
    for i = 1, #team do
        if not team[i].deathInfo then
            count = count + 1
        end
    end
    return count
end

function updatePlayerStat(src, stat, valueToAdd)
    local char = exports["usa-characters"]:GetCharacter(src)
    local doc = exports.essentialmode:getDocument("arena-player-stats", char.get("_id"))
    if doc then
        doc._rev = nil
    else
        doc = {
            kills = 0,
            deaths = 0
        }
    end
    doc[stat] = doc[stat] + valueToAdd
    local ok = exports.essentialmode:updateDocument("arena-player-stats", char.get("_id"), doc, true)
end

function healAndRevivePlayer(src)
    local target = exports["usa-characters"]:GetCharacter(src)
    target.set('injuries', {})
    TriggerClientEvent('death:allowRevive', src)
    TriggerClientEvent('injuries:updateInjuries', src, {})
    TriggerClientEvent('death:revivePed', src)
end

function resetGame()
    currentGame.startTime = nil
    -- reset death state
    for i = 1, #currentGame.team1 do
        currentGame.team1[i].deathInfo = nil
    end
    for i = 1, #currentGame.team2 do
        currentGame.team2[i].deathInfo = nil
    end
    -- trigger game ended client stuff
    for i = 1, #currentGame.team1 do
        TriggerClientEvent("arena:gameEnded", currentGame.team1[i].source)
    end
    for i = 1, #currentGame.team2 do
        TriggerClientEvent("arena:gameEnded", currentGame.team2[i].source)
    end
end

function assignRandomTeams()
    for i = #currentGame.queue, 1, -1 do
        if #currentGame.team1 <= #currentGame.team2 then
            table.insert(currentGame.team1, currentGame.queue[i])
            notifyPlayers(currentGame.queue[i].name .. " has joined team 1")
        else
            table.insert(currentGame.team2, currentGame.queue[i])
            notifyPlayers(currentGame.queue[i].name .. " has joined team 2")
        end
        table.remove(currentGame.queue, i)
    end
end

function triggerPreGameStartClientActions()
    local startWait = os.time()
    while os.difftime(os.time(), startWait) <= 1 do
        Wait(1)
    end
    for i = 1, #currentGame.team1 do
        TriggerClientEvent("arena:gameStarted", currentGame.team1[i].source)
    end
    for i = 1, #currentGame.team2 do
        TriggerClientEvent("arena:gameStarted", currentGame.team2[i].source)
    end
end

AddEventHandler("playerDropped", function(reason)
    for i = 1, #currentGame.team1 do
        if currentGame.team1[i].source == source then
            table.remove(currentGame.team1, i)
            return
        end
    end
    for i = 1, #currentGame.team2 do
        if currentGame.team2[i].source == source then
            table.remove(currentGame.team2, i)
            return
        end
    end
end)

exports["globals"]:PerformDBCheck("usa-arena", "arena-player-stats")