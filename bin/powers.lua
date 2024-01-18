local a = {}
local toggleRas = false
local toggleGV = false
local toggleLaser = false

function func_522(d, e, f)
    local g;
    local h = math.sqrt(d * d + e * e + f * f)
    local i;
    if h ~= 0.0 then
        g = 1.0 / h;
        i = vector3(d, e, f) * vector3(g, g, g)
    end
    return i or vector3(0.0, 0.0, 0.0)
end
function a:registerClass()
    a.constructor()
end
local function o(self)
    local q;
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local r = PlayerPedId()
            self.ped = {
                getId = r,
                getCoords = GetEntityCoords(r),
                getHealth = GetEntityHealth(r),
                getHeading = GetEntityHeading(r)
            }
            q = self.ped;

            if player.inVeh == false and player.isSuper then
                if player.aceJump then
                    player.canSuperJump = true
                end
                SetPedCanRagdoll(r, false)
                SetPlayerFallDistance(PlayerId(), 1000.0)

                DisableControlAction(0, 157, true)
                DisableControlAction(0, 158, true)
                DisableControlAction(0, 160, true)
                DisableControlAction(0, 164, true)
                DisableControlAction(0, 165, true)

                if IsControlPressed(0, 21) then
                    if IsDisabledControlJustReleased(0, 157) and player.aceFly then
                        self:toggleFly()
                    end
                    if IsDisabledControlJustReleased(0, 158) and player.aceRun then
                        self:togglePowerRun()
                    end
                    if IsDisabledControlJustReleased(0, 160) then
                        toggleLaser = not toggleLaser
                    end
                    if IsDisabledControlJustReleased(0, 164) then
                        toggleGV = not toggleGV
                    end
                    if IsDisabledControlJustReleased(0, 165) then
                        toggleRas = true
                    end
                end

                if toggleLaser then
                    castLaser()
                end

                if toggleGV then
                    grabVeh()
                end

                if toggleRas then
                    rasengan()
                end

                if not self.power_run then
                    local u = self.ped.getCoords;
                    local v, w = GetGroundZFor_3dCoord(u.x, u.y, u.z, true)
                    if not self.last_z then
                        self.last_z = u.z
                    end
                    if u.z - self.last_z >= 3 or u.z - self.last_z < -2 then
                        self.is_in_fly = true
                    end
                    if u.z - w <= 1.0 and self.is_in_fly then
                        self:landingOnGround()
                    end
                end
            else

            end
        end
    end)
end
local function I(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if self.power_run then
                if IsPedFalling(self.ped.getId) then
                    self:stopAnim()
                end
                local u = self.ped.getCoords;
                local J = GetEntityForwardVector(self.ped.getId)
                local K = IsPedRunning(self.ped.getId) and 1 or IsPedSprinting(self.ped.getId) and 1 or
                IsPedWalking(self.ped.getId) and 0;
                if not IsPedRagdoll(self.ped.getId) then
                    if K == 1 then
                        local L = GetGameplayCamRelativeHeading() + GetEntityHeading(self.ped.getId)
                        local v, w = GetGroundZFor_3dCoord(u.x, u.y, u.z)
                        local M, N = nil, 60.0;
                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 22, true)
                        if math.floor(u.z) - math.floor(w) >= 1 then
                            M = -30.0
                        else
                            M = 0.0
                        end
                        SetEntityVelocity(self.ped.getId, J.x * N, J.y * N)
                        ApplyForceToEntity(self.ped.getId, 1, J.x * 1, J.y * 1, M, 0.0, 0.0, 0.0, 1, false, true, true,
                            true, true)
                        SetEntityHeading(self.ped.getId, L)
                    elseif K == 0 then
                        FreezeEntityPosition(self.ped.getId, true)
                        FreezeEntityPosition(self.ped.getId, false)
                        Citizen.Wait(1000)
                    end
                end
            else
                break
            end
        end
    end)
end

local function O(self)
    Citizen.CreateThread(function()
        if self.power_run then
            self:togglePowerRun()
        end
        local N = 30;
        Citizen.CreateThread(function()
            while true do
                if not self.fly then
                    break
                end
                if IsControlPressed(1, 150) then
                    if N + 10 <= 1000 then
                        N = N + 10
                    end
                else
                    if N > 30 then
                        N = N - 10
                    end
                end
                Citizen.Wait(100)
            end
        end)
        while true do
            Citizen.Wait(0)
            
            if self.fly then
                local L = GetGameplayCamRelativeHeading() + GetEntityHeading(self.ped.getId)
                local P = GetEntityPitch(self.ped.getId) + GetGameplayCamRelativePitch()
                SetEntityRotation(self.ped.getId, P, 0, L, false, true)
                local J, Q, R, pos = GetEntityMatrix(self.ped.getId)
                if N > 30 then
                    ApplyForceToEntity(self.ped.getId, 1, J.x * N, J.y * N, J.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                else
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                end
                self:playFlyAnim()
                player.isFly = true
                if IsPedFalling(self.ped.getId) then
                    self:stopAnim()
                end
                if IsControlPressed(1, 150) then
                    ApplyForceToEntity(self.ped.getId, 1, J.x * N, J.y * N, J.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                end
                if IsControlPressed(1, 151) then
                    local pos = GetOffsetFromEntityInWorldCoords(self.ped.getId, 0.0, -1.0, 0.0) - self.ped.getCoords;
                    ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                    N = 30
                end
                local u = self.ped.getCoords;
                local v, w = GetGroundZFor_3dCoord(u.x, u.y, u.z, true)
                if IsControlPressed(1, 36) then
                    if v then
                        local pos = u - vec(u.x, u.y, w)
                        ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, -pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                        SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                        TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                    end
                end
                if IsControlPressed(1, 22) then
                    if v then
                        local pos = u - vec(u.x, u.y, w)
                        ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                        SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                        TriggerServerEvent('superv3:SetVelocity', 0.0, 0.0, 0.1)
                    end
                end
            else
                player.isFly = false
                break
            end
        end
    end)
end

function a:playAnim(S, T, U, V)
    local W = 0;
    while not HasAnimDictLoaded(T) and W <= 5000 do
        Citizen.Wait(10)
        W = W + 100;
        RequestAnimDict(T)
    end
    TaskPlayAnim(S, T, U, 8.0, -8.0, -1, V or 0, 0, false, false, false)
    RemoveAnimDict(T)
end
function a:stopAnim()
    ClearPedTasks(self.ped.getId)
end
function a:addDecal(X)
    X = tonumber(X) or 1010;
    local Y = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
    local Z = AddDecal(X, Y.x, Y.y, Y.z, 0.0, 0.0, -1.0, func_522(0.0, 1.0, 0.0), 5.0, 5.0, 255, 255, 255, 1.0, -1.0, 0,
        0, 0)
    return Z
end
function a:toggleFly()
    self.fly = not self.fly;
    if not self.fly then
        FreezeEntityPosition(self.ped.getId, true)
        FreezeEntityPosition(self.ped.getId, false)
        self:stopAnim()
        self.is_in_fly = false;
        self.last_z = false
        player.isFly = false
    else
        O(self)
    end
end
function a:togglePowerRun()
    self.power_run = not self.power_run;
    player.canSuperRun = not player.canSuperRun
    if self.power_run then
        I(self)
        SetEntityMotionBlur(self.ped.getId, true)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    end
    if not self.power_run then
        player.canSuperJump = false
        StopParticleFxLooped(self.run_particle, true)
        SetEntityMotionBlur(self.ped.getId, false)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        FreezeEntityPosition(self.ped.getId, true)
        FreezeEntityPosition(self.ped.getId, false)
    end
end
function a:playFlyAnim()
    if IsControlPressed(1, 150) then
        if not IsEntityPlayingAnim(self.ped.getId, "skydive@freefall", "free_forward", 1) then
            self:stopAnim()
            self:playAnim(self.ped.getId, "skydive@freefall", "free_forward", 1)
        end
    else
        if not IsEntityPlayingAnim(self.ped.getId, "move_m@intimidation@unarmed", "idle", 49) or
            not IsEntityPlayingAnim(self.ped.getId, "skydive@parachute@", "chute_idle", 49) then
            self:playAnim(self.ped.getId, "move_m@intimidation@unarmed", "idle", 49)
            self:playAnim(self.ped.getId, "skydive@parachute@", "chute_idle", 1)
        end
    end
end
function a:playLandingAnim()
    local a3 = {{
        dict = "move_fall@beastjump",
        name = 'high_land_stand'
    }}
    local a4 = math.random(1, #a3)
    local U = a3[a4]
    self:playAnim(self.ped.getId, U.dict, U.name, 1)
end
function a:landingOnGround()
    if player.isFly then
        self.fly = false;
        self.is_in_fly = false;
        self.last_z = false;
        FreezeEntityPosition(self.ped.getId, true)
        FreezeEntityPosition(self.ped.getId, false)
        self:stopAnim()
        PlaySoundFrontend(-1, "QUIT_WHOOSH", "HUD_MINI_GAME_SOUNDSET", false)
        self:playLandingAnim()
        self:addDecal("5000")
        Citizen.Wait(1000)
        
        self:stopAnim()
    end
end
a.constructor = function()
    self = a;
    self.fly = false;
    self.power_run = false;
    self.ped = nil;
    o(self)
end;
a:registerClass()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        collectgarbage()
    end
end)

----

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

function castLaser()
    local playerPed = self.ped.getId
    local index = GetPedBoneIndex(playerPed, 0x6B52)
    local eyeC = GetWorldPositionOfEntityBone(playerPed, index)
    local color = {255, 0, 0, 255}
    local hit, coords, entity, destination = RayCastGamePlayCamera(30.0)

    if hit == 1 then
        DrawLine(eyeC.x, eyeC.y, eyeC.z, coords.x, coords.y, coords.z, color[1], color[2], color[3], color[4])
        AddExplosion(coords.x, coords.y, coords.z, 36, 10.0, false, false, 0)
    else
        DrawMarker(28, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
    end
end

RegisterNetEvent('superv3:ApplyForce', function(e, v, m)
    ApplyForceToEntityCenterOfMass(v, 1, e.x * m, e.y * m, e.z + 50.0, false, false, true, false)
end)

local isAttached = false
local attachedE = nil
local forceMultiplier = 375.0
function grabVeh()
    local playerPed = self.ped.getId
    local index = GetEntityBoneIndexByName(playerPed, "BONETAG_R_FINGER11")
    local hit, coords, entity, destination = RayCastGamePlayCamera(10.0)

    if hit ~= 0 and IsEntityAVehicle(entity) and isAttached == false then
        DrawMarker(42, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, false, true, 2, false, false, false, false)
        if IsControlJustReleased(0, 38) and isAttached == false then
            local dict = "mp_missheist_countrybank@lift_hands"
            LoadAnimDict(dict)
            TaskPlayAnim(playerPed, dict, "lift_hands_in_air_loop", 8.0, -8.0, -1, 50, 0, false, false, false)
            AttachEntityToEntity(entity, playerPed, index, 0.0, 0.0, 0.0, 100.0, 0.0, 75.0, false, false, false, false, 0, true)
            attachedE = entity
            isAttached = true
        end
    else
        DrawMarker(42, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 255, false, true, 2, false, false, false, false)
        if IsControlJustReleased(0, 38) and isAttached == true then
            local _, rightVector, _, _ = GetEntityMatrix(attachedE)
            ClearPedTasks(PlayerPedId())
            DetachEntity(playerPed, true, true)
            DetachEntity(attachedE, true, true)
            TriggerServerEvent('superv3:ValidateAF', rightVector, attachedE, forceMultiplier)
            attachedE = nil
            isAttached = false
        end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ras = nil
local initiateRas = false
local particles = {}
function rasengan()
    local playerPed = self.ped.getId
    local pCoords = GetEntityCoords(playerPed)
    local pRot = GetEntityRotation(playerPed, 2)
    local _, rV, _, pos = GetEntityMatrix(playerPed)
    local cPos = vector3(pos.x + rV.x/2, pos.y + rV.y/2, pos.z - 0.4)
    
    if ras == nil then
        local model = "w_ex_snowball"
        local hash = GetHashKey(model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end
        local e = CreateObject(model, cPos.x, cPos.y, cPos.z, true, true, false)
        ras = e
        SetEntityAlpha(ras, 0, false)
        doesRasExist = true
    end

    if ras ~= nil and initiateRas == false then
        SetEntityCoords(ras, cPos.x, cPos.y, cPos.z, false, false, false, false)
        SetEntityRotation(ras, pRot.x, pRot.y, pRot.z, 2)        
        UseParticleFxAsset("core")
        StartNetworkedParticleFxNonLoopedOnEntity("ent_anim_paparazzi_flash", ras, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, true, false, false)
    end

    if IsControlJustReleased(0, 24) then
        initiateRas = true
        for i = 0, 100, 1 do
            Citizen.Wait(10)
            local fV, _, _, p = GetEntityMatrix(ras)
            
            if i == 1 then
                AddExplosion(pCoords.x, pCoords.y, pCoords.z + 1.3, 70, 10000000000.0, false, false, 0)
            end

            if i > 1 and i < 50 then
                UseParticleFxAsset("core")
                local a = StartNetworkedParticleFxNonLoopedOnEntity("ent_dst_electrical", ras, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
                table.insert(particles, a)
                UseParticleFxAsset("core")
                local b = StartNetworkedParticleFxNonLoopedOnEntity("ent_dst_elec_fire", ras, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
                table.insert(particles, b)
                UseParticleFxAsset("core")
                local c = StartNetworkedParticleFxLoopedOnEntity("ent_amb_foundry_arc_heat", ras, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
                table.insert(particles, c)
                UseParticleFxAsset("core")
                local d = StartNetworkedParticleFxLoopedOnEntity("ent_amb_sparking_wires", ras, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
                table.insert(particles, d)
            end           
            
            if i <= 70 then
                SetEntityCoords(ras, p.x + fV.x/2, p.y + fV.y/2, p.z)
            elseif i > 70 then
                SetEntityCoords(ras, p.x + fV.x/2, p.y + fV.y/2, p.z + 0.1)
            end

            if i > 90 then
                AddExplosion(p.x, p.y, p.z, 82, 100000.0, false, false, 0.0)
            end

            if i == 100 then
                ras = nil
                initiateRas = false
                
                for _, particle in ipairs(particles) do
                    StopParticleFxLooped(particle, true)
                end

                toggleRas = false              
            end
        end            
    end

    --local p = "veh_sub_crush" -- good but resource heavy
    --local p = "proj_laser_enemy" -- for laser eyes
    --local p = "ent_dst_elec_fire" -- good
    --local p = "ent_amb_foundry_arc_heat" -- good
    --local p = "ent_amb_sparking_wires" -- good
    --local p = "ent_dst_electrical" -- good
end