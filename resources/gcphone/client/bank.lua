Citizen.CreateThread(function()
      while true do

            Citizen.Wait(10000)

            TriggerServerEvent("gcphone:bankUpdate")

      end
end)

RegisterNetEvent("gcphone:bankReturn")
AddEventHandler("gcphone:bankReturn", function(bal)
      SendNUIMessage({event = 'updateBankbalance', banking = bal})
end)

RegisterNetEvent("gcphone:bankUpdateNeeded")
AddEventHandler("gcphone:bankUpdateNeeded", function()
      TriggerServerEvent("gcphone:bankUpdate")
end)