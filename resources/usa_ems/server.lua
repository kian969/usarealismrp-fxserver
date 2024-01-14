local DB_NAME = "lsfd-outfits"

exports.globals:PerformDBCheck("usa_ems", DB_NAME)

local JOB_NAME = "ems"

local LOADOUT_ITEMS = {
  { name = "Flashlight", hash = -1951375401, price = 15, weight = 4 },
  { name = "Flare", hash = 1233104067, price = 25, weight = 9 },
  { name = "Fire Extinguisher", hash = 101631238, price = 25, weight = 20 },
  { name = "EMS Radio", price = 500, weight = 5, type = "misc" },
  { name = "Stretcher", price = 400, type = "misc", weight = 35, invisibleWhenDropped = true },
  { name = "Medical Bag", price = 25, weight = 15 }
}

for i = 1, #LOADOUT_ITEMS do
    LOADOUT_ITEMS[i].serviceWeapon = true
    LOADOUT_ITEMS[i].notStackable = true
    LOADOUT_ITEMS[i].quantity = 1
    LOADOUT_ITEMS[i].legality = "legal"
    if not LOADOUT_ITEMS[i].type then
      LOADOUT_ITEMS[i].type = "weapon"
    end
end

RegisterServerEvent("ems:getLoadout")
AddEventHandler("ems:getLoadout", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    for i = 1, #LOADOUT_ITEMS do
        local item = LOADOUT_ITEMS[i]
        item.serialNumber = exports.globals:generateID()
        item.uuid = item.serialNumber
        if char.get("money") >= item.price then
            if char.canHoldItem(item) then
                char.removeMoney(item.price)
                char.giveItem(item)
                if item.hash then
                  TriggerClientEvent("mini:equipWeapon", source, item.hash, false, false)
                end
                TriggerClientEvent("usa:notify", source, "Retrieved a " .. item.name)
            else
                TriggerClientEvent("usa:notify", source, "Unable to get " .. item.name ..". Inventory full.")
            end
        end
    end
end)

RegisterServerEvent("lsfd:loadOutfitById")
AddEventHandler("lsfd:loadOutfitById", function(id)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(src)
    local outfit = exports.essentialmode:getDocument("lsfd-outfits", id)
    TriggerClientEvent("emsstation2:setCharacter", src, outfit)
    if char.get("job") ~= JOB_NAME then
        char.set("job", JOB_NAME)
        TriggerEvent('job:sendNewLog', src, JOB_NAME, true)
        TriggerClientEvent("thirdEye:updateActionsForNewJob", src, JOB_NAME)
    end
    TriggerClientEvent('interaction:setPlayersJob', src, JOB_NAME)
    TriggerEvent("eblips:add", {name = char.getName(), src = src, color = 3})
end)

RegisterServerEvent("lsfd:saveOutfit")
AddEventHandler("lsfd:saveOutfit", function(character, name)
    local src = source
    local char = exports["usa-characters"]:GetCharacter(src)
    if char.get("job") == JOB_NAME then
        -- get next free slot
        local query = {
            _id = {
                ["$regex"] = char.get("_id")
            }
        }
        local outfits = exports.essentialmode:getDocumentsByRows("lsfd-outfits", query)
        local nextSlot = outfits[#outfits]._id:sub(#outfits[#outfits]._id, #outfits[#outfits]._id)
        nextSlot = tonumber(nextSlot) + 1
        -- save
        character.name = name
        local ok = exports.essentialmode:createDocumentWithId(DB_NAME, char.get("_id") .. "-" .. nextSlot, character)
        if ok then
            TriggerClientEvent("usa:notify", src, "Outfit has been saved.")
        else
            TriggerClientEvent("usa:notify", src, "Error saving outfit")
        end
    else
        TriggerClientEvent("usa:notify", source, "You must be on-duty to save a uniform.")
    end
end)

RegisterServerEvent("lsfd:deleteOutfit")
AddEventHandler("lsfd:deleteOutfit", function(id)
    local src = source
    local ok = exports.essentialmode:deleteDocument("lsfd-outfits", id)
    if ok then
        TriggerClientEvent("usa:notify", src, "Outfit deleted")
    else
        TriggerClientEvent("usa:notify", src, "Error deleting outfit")
    end
end)

RegisterServerEvent("emsstation2:onduty")
AddEventHandler("emsstation2:onduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  if char.get("job") ~= JOB_NAME then
    char.set("job", JOB_NAME)
    TriggerClientEvent("thirdEye:updateActionsForNewJob", source, JOB_NAME)
    TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
    TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 1})
  end
end)

RegisterServerEvent("emsstation2:offduty")
AddEventHandler("emsstation2:offduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
  local playerWeapons = char.getWeapons()
  TriggerClientEvent("emsstation2:setciv", source, char.get("appearance"), playerWeapons) -- need to test
  if char.get('job') == JOB_NAME then
      char.set("job", "civ")
      TriggerClientEvent("thirdEye:updateActionsForNewJob", source, "civ")
      TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
      TriggerEvent("eblips:remove", source)
      TriggerClientEvent("radio:unsubscribe", source)
  end
end)

RegisterServerEvent("emsstation2:checkWhitelist")
AddEventHandler("emsstation2:checkWhitelist", function()
	if exports["usa-characters"]:GetCharacterField(source, "emsRank") > 0 then
		TriggerClientEvent("emsstation2:isWhitelisted", source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not whitelisted for EMS. Apply at https://www.usarrp.gg.")
	end
end)

function RemoveServiceWeapons(char)
      local weps = char.getWeapons()
      for i = #weps, 1, -1 do
          if weps[i].serviceWeapon then
              char.removeItemWithField("serialNumber", weps[i].serialNumber)
          end
      end
end

RegisterServerCallback {
  eventName = "lsfd:loadSavedOutfits",
  eventCallback = function(src)
      local char = exports["usa-characters"]:GetCharacter(src)
      local query = {
          _id = {
              ["$regex"] = char.get("_id")
          }
      }
      local outfits = exports.essentialmode:getDocumentsByRows("lsfd-outfits", query)
      local ret = {}
      for i = 1, #outfits do
          table.insert(ret, { name = (outfits[i].name or "Not named"), _id = outfits[i]._id })
      end
      return ret
  end
}