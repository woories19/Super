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
player.aceVision = false
player.aceGrab = false
player.aceRas = false

TriggerServerEvent('superv2:whitelist')
RegisterNetEvent('passed:whitelist', function(perms)
    local next = next
    if perms == 'notAce' or next(perms) == nil then
        player.isAce = false
    else
        player.isAce = true
        for i, v in pairs(perms) do
            if v == 'jump' then
                player.aceJump = true
            end
            if v == 'fly' then
                player.aceFly = true
            end
            if v == 'run' then
                player.aceRun = true
            end
            if v == 'vision' then
                player.aceVision = true
            end
            if v == 'grab' then
                player.aceGrab = true
            end
            if v == 'ras' then
                player.aceRas = true
            end
        end
    end
end)

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
                superUI()
            else
                chat("^1You are not allowed to gain powers!^7 Please contact the server admin.")
            end
        end
    end
end)

--[[ 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        --local player = PlayerPedId()
        --local offset = GetOffsetFromEntityInWorldCoords(player, 0.0, 15.0, 0.0)
        
        --local foundG, z = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z, true)
        --AddExplosion(offset.x, offset.y, z, 82, 100000.0, false, false, 0.0)
        --local debug = DrawMarker(23, offset.x, offset.y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255)
        --print(z)
    end
end)
 ]]