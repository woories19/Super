AddEventHandler('playerJoining', function()
    local data = whitelist
    for k, v in pairs(data) do
        if GetPlayerIdentifiers(source)[1] == data[k] then
            print(data[k])
            print("Player "..GetPlayerName(source).." is joining with whitelist!")
        end
    end
end)

RegisterNetEvent('superv2:whitelist', function()
    local data = whitelist
    local p = GetPlayerIdentifiers(source)[1]
    if data[p] then
        local perms = data[p]
        TriggerClientEvent('passed:whitelist', source, perms)
    else
        TriggerClientEvent('passed:whitelist', source, 'notAce')
    end
end)

RegisterNetEvent("superv3:ValidateAF", function(a, b)
    TriggerClientEvent("superv3:ApplyForce", source, a, b)
end)

RegisterNetEvent("superv3:DeleteEntity", function(entity)
    if not DoesEntityExist(entity) then

        return
    end
    DeleteEntity(entity)
end)


