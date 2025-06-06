local blips = {}
local showBlips = false

RegisterNetEvent('esx_pblips_local:toggleBlips')
AddEventHandler('esx_pblips_local:toggleBlips', function()
    showBlips = not showBlips

    if not showBlips then
        for _, blip in pairs(blips) do
            RemoveBlip(blip)
        end
        blips = {}
        return
    end

    Citizen.CreateThread(function()
        while showBlips do
            for _, id in ipairs(GetActivePlayers()) do
                if id ~= PlayerId() then
                    local ped = GetPlayerPed(id)
                    local serverId = GetPlayerServerId(id)

                    if DoesEntityExist(ped) then
                        local blip = blips[serverId]
                        local coords = GetEntityCoords(ped)

                        if not blip then
                            blip = AddBlipForEntity(ped)
                            SetBlipSprite(blip, 1)
                            SetBlipScale(blip, 0.85)
                            SetBlipColour(blip, 29)
                            SetBlipCategory(blip, 7)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Spieler")
                            EndTextCommandSetBlipName(blip)
                            blips[serverId] = blip
                        else
                            SetBlipCoords(blip, coords.x, coords.y, coords.z)
                        end
                    end
                end
            end
            Wait(2000)
        end
    end)
end)
