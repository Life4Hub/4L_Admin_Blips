local blips = {}      -- [serverId] = blip handle
local showing = false
local nameCache = {}

-- Receive name cache from server (periodic)
RegisterNetEvent('4l_pblips:names', function(map)
    nameCache = map or {}
end)

-- Receive positions snapshot from server
RegisterNetEvent('4l_pblips:positions', function(positions)
    if not showing then return end

    local seen = {}

    for serverId, pos in pairs(positions or {}) do
        seen[serverId] = true

        local blip = blips[serverId]
        if not blip or blip == 0 then
            blip = AddBlipForCoord(pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
            blips[serverId] = blip

            -- Always long range
            SetBlipAsShortRange(blip, false)
            SetBlipHighDetail(blip, true)
            if (Config and Config.ShowInLegend == false) then SetBlipHiddenOnLegend(blip, true) else SetBlipHiddenOnLegend(blip, false) end
            -- Display on both minimap and big map (value 8 works reliably in FiveM)
            SetBlipDisplay(blip, 2)

            -- Appearance from Config
            SetBlipSprite(blip, 1)
            SetBlipScale(blip, scale + 0.0)
            SetBlipColour(blip, colour)
            if cat then SetBlipCategory(blip, cat) end
        else
            -- Move existing blip
            SetBlipCoords(blip, pos.x + 0.0, pos.y + 0.0, pos.z + 0.0)
        end

        -- Label (ESX char name if available)
        local label = (nameCache and nameCache[serverId]) or (Config and Config.Blip and Config.Blip.Name) or "Spieler"
        local key = ("4L_PBL_%s"):format(serverId)
        AddTextEntry(key, tostring(label))
        SetBlipNameFromTextFile(blip, key)
    end

    -- Remove blips for players no longer present
    for sid, blip in pairs(blips) do
        if not seen[sid] then
            if blip and blip ~= 0 then RemoveBlip(blip) end
            blips[sid] = nil
        end
    end
end)

-- Toggle
RegisterNetEvent('4l_pblips:toggle', function()
    showing = not showing

    if showing then
        -- subscribe to server updates
        TriggerServerEvent('4l_pblips:subscribe')
        -- show a small toast
        TriggerEvent('chat:addMessage', { args = { '^2Player Blips', '^7Aktiviert – Live‑Blips werden angezeigt.' } })
    else
        -- unsubscribe & cleanup
        TriggerServerEvent('4l_pblips:unsubscribe')
        for sid, blip in pairs(blips) do
            if blip and blip ~= 0 then RemoveBlip(blip) end
        end
        blips = {}
        TriggerEvent('chat:addMessage', { args = { '^2Player Blips', '^7Deaktiviert – Blips entfernt.' } })
    end
end)

-- Safety: clear blips on resource stop
AddEventHandler('onClientResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, blip in pairs(blips) do
        if blip and blip ~= 0 then RemoveBlip(blip) end
    end
end)
