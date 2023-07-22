CreateThread(function()
	while true do
		Wait(0)
		if IsDisabledControlJustPressed(1, 166) then
			SetFlash(0, 0, 100, 100, 100)
			Wait(100)
			PlaySoundFrontend(-1, 'FocusIn', 'HintCamSounds', 1)
            TriggerEvent("hud:client:ToggleCinematic")
		end
	end
end)