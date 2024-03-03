local CHECK_INTVERAL_SECONDS = 35
local DROPPED_AMOUNT_LG = 20
local DROPPED_AMOUNT_MD = 10
local DROPPED_AMOUNT_SM = 5

local lastRecordedAmount = 0

local WEBHOOK_URL = GetConvar("server-monitor-webhook", "")
local DISCORD_IDENT_TO_PING = GetConvar("server-monitor-discord-ident", "")

local statistics = {
    ["playerDrops"] = 0,
    ["abnormalDrops"] = 0,
    ["players"] = {
        uniqueCount = 0,
        recorded = {}
    },
    ["startTime"] = os.time(),
    ["crashes"] = {}
}

Citizen.CreateThread(function()
    while true do 
        local curCount = #GetPlayers()
        if curCount < lastRecordedAmount then
            local numDropped = lastRecordedAmount - curCount
            if numDropped >= DROPPED_AMOUNT_MD then
                local msg = "\nSignificant player drop event detected!\nAt least " .. numDropped .. " player(s) dropped in no more than " .. CHECK_INTVERAL_SECONDS .. " seconds!"
                if DISCORD_IDENT_TO_PING then
                    msg = msg .. " <@" .. DISCORD_IDENT_TO_PING .. ">"
                end
                SendDiscordLog(WEBHOOK_URL, msg)
            end
        end
        lastRecordedAmount = #GetPlayers()
        Wait(CHECK_INTVERAL_SECONDS * 1000)
    end
end)

AddEventHandler('playerJoining', function(src, oldId)
    local ident = GetPlayerIdentifiers(source)[1]
    local entry = statistics["players"].recorded[ident]
    if not entry and ident then
        statistics["players"].recorded[ident] = true
        statistics["players"].uniqueCount = statistics["players"].uniqueCount + 1
    end
end)

AddEventHandler("playerDropped", function(reason)
    reason = reason:lower()
    if reason:find("game crashed") or reason:find("timed out") then
        local timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())
        local msg = "\nPlayer " .. GetPlayerName(source) .. " (#" .. source .. " / " .. GetPlayerIdentifiers(source)[1] .. ") dropped with reason: " .. reason .. " at " .. timestamp
        SendDiscordLog(WEBHOOK_URL, msg)
        statistics["abnormalDrops"] = statistics["abnormalDrops"] + 1
        if not statistics["crashes"][reason] then 
            statistics["crashes"][reason] = 1
        else 
            statistics["crashes"][reason] = statistics["crashes"][reason] + 1
        end
    end
    statistics["playerDrops"] = statistics["playerDrops"] + 1
end)

function SendDiscordLog(url, msg, stat)
    if stat then
        msg = msg .. "\n**Requested Stat:** " .. statistics[stat]
    end
    PerformHttpRequest(url, function(err, text, headers)
    end, "POST", json.encode({
        content = msg
    }), { ["Content-Type"] = 'application/json' })
end

function SendServerMonitorDiscordMsg(msg, stat)
    SendDiscordLog(WEBHOOK_URL, msg, stat)
end

AddEventHandler('rconCommand', function(commandName, args)
    commandName = commandName:lower()
    if commandName == 'showstats' then
        local abnormalDropPercentage = math.floor(math.floor(statistics["abnormalDrops"] / statistics["playerDrops"]) * 100)
        RconPrint("Recorded # of drops since last restart: " ..  statistics["playerDrops"] .. ".")
        RconPrint("\nRecorded # of abnormal drops since last restart: " ..  statistics["abnormalDrops"] .. ".")
        RconPrint("\nRecorded # of unique player joins since last restart: " ..  statistics["players"].uniqueCount .. ".")
        RconPrint("\nAbnormal drop percentage since last restart: " ..  abnormalDropPercentage .. "%")
        RconPrint("\nThe most frequent player drop reason so far is: " .. GetMostFrequentPlayerDropReason())
        CancelEvent()
    elseif commandName == "crashstats" then
        RconPrint("Today's Crash Statistics (reason / count):")
        -- fill an array to sort --
        local crashes = {}
        for reason, count in pairs(statistics["crashes"]) do 
            table.insert(crashes, {reason = reason, count = count})
        end
        -- sort by count --
        table.sort(crashes, function(a, b) 
            if a.count > b.count then
                return true
            else 
                return false
            end
        end)
        -- print --
        for i = 1, #crashes do 
            local reason = crashes[i].reason
            local count = crashes[i].count
            RconPrint("\n" .. reason .. " happened " .. count .. " time(s).")
        end
        CancelEvent()
    end
end)

function GetMostFrequentPlayerDropReason()
    local mostFreq = {
        count = -1,
        str = "N/A"
    }
    for reason, count in pairs(statistics["crashes"]) do
        if count > mostFreq.count then 
            mostFreq.count = count
            mostFreq.str = reason
        end
    end
    return mostFreq.str
end