RegisterCommand('pblips', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job and xPlayer.job.name == 'Homeland' then
        TriggerClientEvent('esx_pblips_local:toggleBlips', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Du bist nicht berechtigt, diesen Befehl zu benutzen."}
        })
    end
end)
