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

local g = true

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

-- Get Ped In Direction
function castRay( coordFrom, coordTo )
    local rayHandle = StartShapeTestLosProbe( coordFrom.x, coordFrom.y, coordFrom.z - 0.3, coordTo.x, coordTo.y, coordTo.z, 4294967295, GetPlayerPed( -1 ), 4 )
    local _, hit, endCoords, _, entity = GetRaycastResult( rayHandle )
    return entity
end

--[[ 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if g == false then
            local retVal, coords = GetPedLastWeaponImpactCoord(PlayerPedId())
            if retVal then
                
                AddExplosion(coords.x, coords.y, coords.z, 70, 10000000000.0, true, false, 0)
                SetPtfxAssetNextCall("core")
                StartParticleFxLoopedAtCoord("ent_dst_electrical",coords.x,coords.y,coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                SetPtfxAssetNextCall("des_tv_smash")
                StartParticleFxLoopedAtCoord("ent_sht_electrical_box_sp",coords.x,coords.y,coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                
            end
            SetExplosiveMeleeThisFrame(PlayerId())      
        end
    end
end)
 ]]

function superPunch(entity)
    local playerPed = PlayerPedId()
    local e = entity
    local isPed = IsEntityAPed(entity)
    local isVeh = IsEntityAVehicle(entity)
    if isPed then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local coords = GetEntityCoords(e)
                local coordsOffset = GetOffsetFromEntityInWorldCoords(e, 0.0, 1.0, 0.0)
                local dMarker = DrawMarker(42, coordsOffset.x, coordsOffset.y, coordsOffset.z + 0.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                local v, w = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true)
                FreezeEntityPosition(e, true)
                SetEntityCoords(e, coords.x, coords.y + 0.1, w)
            end
        end)
        --[[ 
        local pH = GetEntityHeading(playerPed)
        local calceH = (pH + 360) - 180
        if calceH >= 360 then
            calceH = calceH - 360
        end
        local eH = SetEntityHeading(entity, calceH)
        Citizen.Wait(100)
        ClearPedTasks(entity)
        ClearRagdollBlockingFlags(entity)
        SetPedCanRagdoll(entity, true)
        ApplyForceToEntity(entity, 1, 0.0, 1000.0, 80.0, 0.0, 0.0, 0.0, 1, false, true, true, false, true)
        --ApplyForceToEntityCenterOfMass(ped, 1, 0.0, -100.0, 0.0, true, true)
        --SetEntityVelocity(e, 0.0, 0.3, 0.3)
        --ApplyDamageToPed(e, 500, false)
         ]]
        print("ped")
    end

    if isVeh then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local coords = GetEntityCoords(e)
                local coordsOffset = GetOffsetFromEntityInWorldCoords(e, 0.0, 1.0, 0.0)
                local dMarker = DrawMarker(42, coordsOffset.x, coordsOffset.y, coordsOffset.z + 0.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            end
        end)
        --[[ 
        local pH = GetEntityHeading(playerPed)
        local calceH = (pH + 360) - 180
        if calceH >= 360 then
            calceH = calceH - 360
        end
        local eH = SetEntityHeading(entity, calceH)
        ApplyForceToEntity(entity, 1, 0.0, 500.0, 30.0, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
        --ApplyForceToEntityCenterOfMass(e, 1, h.x * forceMagnitude, h.y * forceMagnitude, 0.0, true, true)
        --SetEntityVelocity(e, 0.0, 0.3, 0.6)
         ]]
        print("veh")
    end
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	vector3(
		-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		math.sin(adjustedRotation.x))
	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 4294967295, PlayerPedId(), 4))
	return b, c, e, destination
end

function castLaser()
    local playerPed = PlayerPedId()
    local index = GetPedBoneIndex(playerPed, 0x6B52)
    local eyeC = GetWorldPositionOfEntityBone(playerPed, index)
    local color = {255, 0, 0, 255}
    local hit, coords, entity, destination = RayCastGamePlayCamera(30.0)
    
    if hit == 1 then
        DrawLine(eyeC.x, eyeC.y, eyeC.z, coords.x, coords.y, coords.z, color[1], color[2], color[3], color[4])
        --DrawMarker(42, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, true, 2, false, false, false, false)
        AddExplosion(coords.x, coords.y, coords.z, 36, 10.0, false, false, 0)
    else
        DrawMarker(28, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
    end
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    
    while not HasAnimDictLoaded(dict) do
      Wait(500)
    end
end



RegisterNetEvent("superv3:ApplyForce", function(rightVector, attachedEntity)
    print("applying force")

    ApplyForceToEntity(attachedEntity, 1, rightVector.x * 40000.0, rightVector.y * 40000.0, rightVector.z + 10000.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
end)



local isAttached = false
local attachedE = nil
local carryAnim = true
function grabVeh()
    local playerPed = PlayerPedId()  
    local index = GetEntityBoneIndexByName(playerPed, "BONETAG_R_FINGER11")
    local hit, coords, entity, destination = RayCastGamePlayCamera(10.0)

    if hit ~= 0 and IsEntityAVehicle(entity) and isAttached == false then
        DrawMarker(6, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, false, true, 2, false, false, false, false)
        
        if IsControlJustReleased(0, 38) and isAttached == false then
            local dict = "mp_missheist_countrybank@lift_hands"
            LoadAnimDict(dict)
            TaskPlayAnim(playerPed, dict, "lift_hands_in_air_loop", 8.0, -8.0, -1, 50, 0, false, false, false)
            AttachEntityToEntity(entity, playerPed, index, 0.0, 0.0, 0.0, 100.0, 0.0, 75.0, false, false, false, false, 0, true)
            attachedE = entity
            isAttached = true
            --print(attachedE)
            --print("entity attached")
        end
    else
        DrawMarker(6, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 255, false, true, 2, false, false, false, false)
        if IsControlJustReleased(0, 38) and isAttached == true then
            local _, rightVector, _, _ = GetEntityMatrix(attachedE)
            ClearPedTasks(PlayerPedId())
            DetachEntity(playerPed, true, true)
            DetachEntity(attachedE, true, true)
            TriggerServerEvent("superv3:ValidateAF", rightVector, attachedE)
            --ApplyForceToEntity(attachedE, 1, rightVector.x * 40000.0, rightVector.y * 40000.0, rightVector.z + 10000.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
            attachedE = nil
            isAttached = false
            print("entity detached") 
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local coordsOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 25.0, -0.5)
        grabVeh()
        --castLaser()
        --local e = castRay( playerCoords, coordsOffset )


        --local dMarker = DrawMarker(42, coordsOffset.x, coordsOffset.y, coordsOffset.z + 0.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
        --[[ 
        if e ~= 0 then
            --superPunch(e)
        end
         ]]
    end
end)