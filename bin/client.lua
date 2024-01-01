print("^1 Super loaded! ^0")

player = {}

player.isSuper = false
player.inVeh = false
player.canSuperJump = false
player.canSuperRun = false
player.isFly = false

player.isAce = false
player.aceRun = false
player.aceFly = false
player.aceJump = false

TriggerServerEvent('superv2:whitelist')
RegisterNetEvent('passed:whitelist', function(perms)
    local next = next
    if perms == 'notAce' or next(perms) == nil then
        player.isAce = false
    else
        player.isAce = true
        for i, v in pairs(perms) do
            if v == 'run' then
                player.aceRun = true
            end
            if v == 'jump' then
                player.aceJump = true
            end
            if v == 'fly' then
                player.aceFly = true
            end
        end
    end
end)

function chat(str)
    TriggerEvent('chat:addMessage', {
        color = {255,255,255},
        multiline = true,
        args = {"System", str}
    })
end

function super()
    local playerPed = GetPlayerPed()
    if not player.isSuper then
        player.isSuper = true

        if superConfig.chatMsg then
            chat("^1^*Superpowers Activated!")
        end
        if superConfig.invincibility then
            SetEntityInvincible(GetPlayerPed(-1), true)
        end
    else
        player.isSuper = false
        player.canSuperJump = false
        player.canSuperRun = false
        SetEntityInvincible(GetPlayerPed(-1), false)
        if superConfig.chatMsg then
            chat("^1^*Superpowers Deactivated!")
        end
    end
end
Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        
        local eid = 258
        NetworkSetEntityInvisibleToNetwork(eid,true)

        if player.aceRun and player.isSuper then
            RestorePlayerStamina(PlayerId(-1), 1.0)
        end

        if IsPedInAnyVehicle(PlayerPedId(), true) then
            player.inVeh = true
        else
            player.inVeh = false
        end

        if player.canSuperJump and player.canSuperRun == false then
            SetSuperJumpThisFrame(PlayerId(-1))
        end

        if IsControlJustReleased(0, superConfig.activate) and player.inVeh == false then
            if player.isAce then
                super()
                if player.aceFly and player.aceRun then
                    UI()
                elseif player.aceFly then
                    UI2()
                elseif player.aceRun then
                    UI3()
                elseif player.aceFly == false and player.aceRun == false then
                    UI4()
                end
            else
                chat("^1You are not allowed to gain powers!^7 Please contact the server admin.")
            end
        end
    end
end)