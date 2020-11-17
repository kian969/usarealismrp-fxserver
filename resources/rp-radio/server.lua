local ALLOWED_FREQUENCYS_BY_JOB = {
    ["sheriff"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 },
    ["corrections"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
    ["ems"] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 , 12, 13},
    ["mechanic"] = { 1, 11, 12 },
    ["civ"] = { 1, 11 },
    ["doctor"] = { 1, 2, 3, 11 },
    ["pilot"] = { 1, 13}
}

local CAN_CIVS_USE = true

--local radioItem = { name = "Radio", price = 350, type = "misc", quantity = 1, legality = "legal", weight = 7, objectModel = "prop_cs_hand_radio", blockedInPrison = true}
--exports["usa_stores"]:AddGeneralStoreItem("Misc", radioItem)

RegisterServerEvent("radio:accessCheck")
AddEventHandler("radio:accessCheck", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local cjob = char.get("job")
    if (not CAN_CIVS_USE and cjob == "civ") or not ALLOWED_FREQUENCYS_BY_JOB[cjob] then
        TriggerClientEvent("usa:notify", source, "Job does not have radio access")
        return
    end
    local permittedFrequencies = GetPermittedFrequenciessForJob(cjob)
    TriggerClientEvent("Radio.Set", source, permittedFrequencies)
end)

function GetPermittedFrequenciessForJob(job)
    local chans = {}
    local allowedFreqs = {}
    if not ALLOWED_FREQUENCYS_BY_JOB[job] then 
        allowedFreqs = { 1, 6} -- default civ freqs
    else
        allowedFreqs = ALLOWED_FREQUENCYS_BY_JOB[job]
    end
    for i = 1, #allowedFreqs do
        local chanToInsert = Channels[allowedFreqs[i]]
        table.insert(chans, chanToInsert)
    end
    return chans
end