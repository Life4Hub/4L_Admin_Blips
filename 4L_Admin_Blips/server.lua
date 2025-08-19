if not ESX then ESX = exports['es_extended']:getSharedObject() end

local viewers = {}         -- [src] = true if player toggled the view
local running = false
local updateInterval = 1000

CreateThread(function()
    while GetResourceState(GetCurrentResourceName()) ~= "started" do
        Wait(50)
    end
    -- allow config override
    if Config and Config.UpdateInterval then
        updateInterval = Config.UpdateInterval
    end
end)

-- Helper: is a job allowed
local function isAllowedJob(xPlayer)
    if not xPlayer or not xPlayer.job or not xPlayer.job.name then return false end
    local jn = string.lower(xPlayer.job.name or "")
    for _, allowed in ipairs(Config.AllowedJobs or {}) do
        if jn == string.lower(allowed) then return true end
    end
    return false
end

-- Get a player's display name (ESX char name preferred, fallback to name or id)
local function displayNameFor(src)
    local xp = ESX.GetPlayerFromId(src)
    if xp and xp.getName then
        local n = xp:getName()
        if n and n ~= "" then return n end
    end
    if xp and xp.get ~= nil then
        -- ESX Legacy character name fields (varies by framework setup)
        local firstname = xp.get and xp.get("firstName") or xp.get and xp.get("firstname")
        local lastname  = xp.get and xp.get("lastName")  or xp.get and xp.get("lastname")
        if firstname or lastname then
            return (tostring(firstname or "") .. " " .. tostring(lastname or "")):gsub("^%s*(.-)%s*$", "%1")
        end
    end
    -- fallback to server id or Rockstar name
    local name = GetPlayerName(src) or ("ID " .. tostring(src))
    return name
end

-- Build and broadcast names map to all current viewers
local function pushNames()
    local names = {}
    for _, pid in ipairs(GetPlayers()) do
        local sid = tonumber(pid)
        names[sid] = displayNameFor(sid)
    end
    for v,_ in pairs(viewers) do
        TriggerClientEvent('4l_pblips:names', v, names)
    end
end

-- Periodic positions publisher (server -> viewers)
local function ensureTicker()
    if running then return end
    running = true
    CreateThread(function()
        while next(viewers) ~= nil do
            local positions = {}
            -- Collect every player's position from the SERVER (works out of client routing range)
            for _, pid in ipairs(GetPlayers()) do
                local sid = tonumber(pid)
                local ped = GetPlayerPed(sid)
                if ped and ped ~= 0 then
                    local coords = GetEntityCoords(ped)
                    positions[sid] = { x = coords.x + 0.0, y = coords.y + 0.0, z = coords.z + 0.0 }
                end
            end

            -- Broadcast positions and (less frequently) names
            for v,_ in pairs(viewers) do
                TriggerClientEvent('4l_pblips:positions', v, positions)
            end

            -- refresh names every ~10 ticks to keep labels accurate
            if math.random(1,10) == 5 then
                pushNames()
            end

            Wait(updateInterval)
        end
        running = false
    end)
end

-- Commands (aliases)
local function toggleCmd(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not isAllowedJob(xPlayer) then
        TriggerClientEvent('chat:addMessage', src, { args = { '^1System', '^7Du bist nicht berechtigt, diesen Befehl zu benutzen.' } })
        return
    end
    TriggerClientEvent('4l_pblips:toggle', src)
end

RegisterCommand('playerblips', function(source) toggleCmd(source) end, false)
RegisterCommand('pblips',      function(source) toggleCmd(source) end, false)
RegisterCommand('blips',       function(source) toggleCmd(source) end, false)

-- Viewer lifecycle
RegisterNetEvent('4l_pblips:subscribe', function()
    local src = source
    viewers[src] = true
    pushNames()
    ensureTicker()
end)

RegisterNetEvent('4l_pblips:unsubscribe', function()
    local src = source
    viewers[src] = nil
end)

AddEventHandler('playerDropped', function(_, src)
    viewers[src or source] = nil
end)
