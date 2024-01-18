AddEventHandler('playerJoining', function()
    local data = whitelist
    local p = GetPlayerIdentifiers(source)[1]
    if data[p] then
        print("Player "..GetPlayerName(source).." is joining with whitelist!")
    end
end)

RegisterNetEvent('superv2:whitelist', function()
    local data = whitelist
    local p = GetPlayerIdentifiers(source)[1]
    if data[p] then
        local perms = data[p]
        print(perms[1], perms[2], perms[3])
        TriggerClientEvent('passed:whitelist', source, perms)
    else
        TriggerClientEvent('passed:whitelist', source, "notAce")
    end
end)

RegisterNetEvent('superv3:ValidateAF', function(a, b, c)
    TriggerClientEvent('superv3:ApplyForce', source, a, b, c)
end)

RegisterNetEvent('superv3:SetVelocity', function(x, y, z)
    SetEntityVelocity(source, x, y, z)
end)