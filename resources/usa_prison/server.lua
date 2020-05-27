---------------
-- the prison --
----------------
local cellblockOpen = false

TriggerEvent('es:addJobCommand', 'c', {"corrections"}, function(source, args, char)
	cellblockOpen = not cellblockOpen
	print("cellblock is now: " .. tostring(cellblockOpen))
	TriggerClientEvent('toggleJailDoors', -1, cellblockOpen)
end)

RegisterServerEvent("jail:checkJobForWarp")
AddEventHandler("jail:checkJobForWarp", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == "sheriff" or job == "ems" or job == "fire" or job == "corrections" or job == "doctor" then
		TriggerClientEvent("jail:continueWarp", source)
	else
		TriggerClientEvent("usa:notify", source, "That area is prohibited!")
	end
end)

------------------------------
-- correctional officer job --
------------------------------
RegisterServerEvent("doc:checkWhitelist")
AddEventHandler("doc:checkWhitelist", function(loc)
	local char = exports["usa-characters"]:GetCharacter(source)
	if char.get('bcsoRank') > 0 then
		TriggerClientEvent("doc:open", source)
	else
		TriggerClientEvent("usa:notify", source, "You don't work here!")
	end
end)

RegisterServerEvent("doc:offduty")
AddEventHandler("doc:offduty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	-------------------------
	-- put back to civ job --
	-------------------------
	if job == "corrections" then
		TriggerEvent('job:sendNewLog', source, 'BCSO', false)
	end
	char.set("job", "civ")
	TriggerClientEvent("usa:notify", source, "You have clocked out!")
	TriggerEvent("eblips:remove", source)
	TriggerClientEvent("interaction:setPlayersJob", source, "civ")
	local playerWeapons = char.getWeapons()
	local appearance = char.get("appearance")
	TriggerClientEvent("doc:setciv", source, appearance, playerWeapons)
	-----------------------------------
	-- change back into civ clothing --
	-----------------------------------
	--print("closing DOC menu!")
	TriggerClientEvent("doc:close", source)
	TriggerClientEvent("ptt:isEmergency", source, false)
	TriggerClientEvent("radio:unsubscribe", source)
end)

RegisterServerEvent("doc:forceDuty")
AddEventHandler("doc:forceDuty", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job ~= "corrections" then
		----------------------------
		-- set to corrections job --
		----------------------------
		char.set("job", "corrections")
		TriggerEvent("doc:loadUniform", 1, source)
		TriggerClientEvent("usa:notify", source, "You have clocked in!")
		TriggerEvent('job:sendNewLog', source, 'corrections', true)
		TriggerClientEvent("ptt:isEmergency", source, true)
		TriggerClientEvent("interaction:setPlayersJob", source, "corrections")
		TriggerEvent("eblips:add", {name = char.getName(), src = source, color = 82})
	end
end)

RegisterServerEvent("doc:refreshEmployees")
AddEventHandler("doc:refreshEmployees", function()
	loadDOCEmployees()
end)

RegisterServerEvent("doc:saveOutfit")
AddEventHandler("doc:saveOutfit", function(uniform, slot)
	local usource = source
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			local uniforms = result.uniform or {}
			uniforms[tostring(slot)] = uniform
			db.updateDocument("correctionaldepartment", result._id, {uniform = uniforms}, function()
				TriggerClientEvent("usa:notify", usource, "Uniform saved!")
			end)
		end)
	end)
end)

RegisterServerEvent("doc:loadOutfit")
AddEventHandler("doc:loadOutfit", function(slot, id)
	if id then source = id end
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local job = char.get("job")
	local player_identifer = GetPlayerIdentifiers(usource)[1]
	if job ~= "corrections" then
		char.set("job", "corrections")
		TriggerEvent('job:sendNewLog', source, 'corrections', true)
		TriggerClientEvent("usa:notify", usource, "You have clocked in!")
		TriggerClientEvent("ptt:isEmergency", usource, true)
		TriggerClientEvent("interaction:setPlayersJob", usource, "corrections")
		TriggerEvent("eblips:add", {name = char.getName(), src = usource, color = 82})
	end
	TriggerEvent('es:exposeDBFunctions', function(usersTable)
		usersTable.getDocumentByRow("correctionaldepartment", "identifier" , player_identifer, function(result)
			if result and result.uniform then
				TriggerClientEvent("doc:uniformLoaded", usource, result.uniform[tostring(slot)] or nil)
			end
		end)
	end)
end)

RegisterServerEvent("doc:spawnVehicle")
AddEventHandler("doc:spawnVehicle", function(hash)
	local char = exports["usa-characters"]:GetCharacter(source)
	local job = char.get("job")
	if job == "corrections" then
		TriggerClientEvent("doc:spawnVehicle", source, hash)
	else
		TriggerClientEvent("usa:notify", source, "You are not on-duty!")
	end
end)

-- weapon rank check --
RegisterServerEvent("doc:checkRankForWeapon")
AddEventHandler("doc:checkRankForWeapon", function(weapon)
	local usource = source
	local char = exports["usa-characters"]:GetCharacter(usource)
	local job = char.get("job")
	if job == "corrections" then
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , GetPlayerIdentifiers(usource)[1], function(result)
				if type(result) ~= "boolean" then
					if result.rank >= weapon.rank then
						if char.canHoldItem(weapon) then
							if char.get("money") < weapon.price then
								TriggerClientEvent("usa:notify", usource, "Not enough money!")
								return
							end
							char.removeMoney(weapon.price)
							local letters = {}
							for i = 65,  90 do table.insert(letters, string.char(i)) end -- add capital letters
					        local serialEnding = math.random(100000000, 999999999)
					        local serialLetter = letters[math.random(#letters)]
					        weapon.serialNumber = serialLetter .. serialEnding
							weapon.uuid = weapon.serialNumber
							TriggerClientEvent("doc:equipWeapon", usource, weapon)
							char.giveItem(weapon)
							local weaponDB = {}
					        weaponDB.name = weapon.name
					        weaponDB.serialNumber = serialLetter .. serialEnding
					        weaponDB.ownerName = char.getFullName()
					        weaponDB.ownerDOB = char.get('dateOfBirth')
							local timestamp = os.date("*t", os.time())
					        weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
							TriggerEvent('es:exposeDBFunctions', function(db)
					          db.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
					              if success then
					                  print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
					              else
					                  print("* Error: Weapon failed to be created!! *")
					              end
					          end)
					        end)
						else
							TriggerClientEvent("usa:notify", usource, "Inventory full!")
						end
					else
						TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
					end
				else
					print("Error: failed to get employee from db")
				end
			end)
		end)
	else
		TriggerClientEvent("usa:notify", usource, "You are not on-duty!")
	end
end)

-- adding new DOC employees --
TriggerEvent('es:addJobCommand', 'setcorrectionsrank', {"corrections"}, function(source, args, user)
	local usource = source
	if not GetPlayerName(tonumber(args[2])) or not tonumber(args[3]) then
		TriggerClientEvent("usa:notify", source, "Error: bad format!")
		return
	end
	local whitelister_identifier = GetPlayerIdentifiers(usource)[1]
	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
		GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , whitelister_identifier, function(result)

			if type(result) == "boolean" then
				return
			end

			if result.rank < 4 then
				TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
				return
			end

			if result.rank <= tonumber(args[3]) then
				TriggerClientEvent("usa:notify", usource, "Not a high enough rank!")
				return
			end

			local target = exports["usa-characters"]:GetCharacter(tonumber(args[2]))
			local employee = {
				identifier = GetPlayerIdentifiers(tonumber(args[2]))[1],
				name = target.getFullName(),
				rank = tonumber(args[3])
			}

			GetDoc.getDocumentByRow("correctionaldepartment", "identifier" , employee.identifier, function(result)
				if type(result) ~= "boolean" then
					GetDoc.updateDocument("correctionaldepartment", result._id, {rank = employee.rank}, function()
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "updated, rank: " .. employee.rank .. "!")
						loadDOCEmployees()
					end)
				else
					-- insert into db --
					GetDoc.createDocument("correctionaldepartment", employee, function()
						-- notify:
						TriggerClientEvent('chatMessage', usource, "", {255, 255, 255}, "^0Employee " .. employee.name .. "created, rank: " .. employee.rank .. "!")
						-- refresh employees:
						loadDOCEmployees()
					end)
				end
			end)
		end)
	end)
end)

function getBCSORank(id, cb)
	TriggerEvent('es:exposeDBFunctions', function(db)
		db.getDocumentByRow("correctionaldepartment", "identifier" , GetPlayerIdentifiers(id)[1], function(doc)
			if doc and doc.rank then
				cb(doc.rank)
			else
				cb(nil)
			end
		end)
	end)
end