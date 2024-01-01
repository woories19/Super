local a = {}

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
                if IsControlJustPressed(0, superConfig.fly) and player.aceFly then
                    self:toggleFly()
                end
                if IsControlJustPressed(0, superConfig.run) and player.aceRun then
                    self:togglePowerRun()
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
                else
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                end
                self:playFlyAnim()
                player.isFly = true
                if IsPedFalling(self.ped.getId) then
                    self:stopAnim()
                end
                if IsControlPressed(1, 150) then
                    ApplyForceToEntity(self.ped.getId, 1, J.x * N, J.y * N, J.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                end
                if IsControlPressed(1, 151) then
                    local pos = GetOffsetFromEntityInWorldCoords(self.ped.getId, 0.0, -1.0, 0.0) - self.ped.getCoords;
                    ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                    SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    N = 30
                end
                local u = self.ped.getCoords;
                local v, w = GetGroundZFor_3dCoord(u.x, u.y, u.z, true)
                if IsControlPressed(1, 36) then
                    if v then
                        local pos = u - vec(u.x, u.y, w)
                        ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, -pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                        SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
                    end
                end
                if IsControlPressed(1, 22) then
                    if v then
                        local pos = u - vec(u.x, u.y, w)
                        ApplyForceToEntity(self.ped.getId, 1, pos.x * N, pos.y * N, pos.z * N, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
                        SetEntityVelocity(self.ped.getId, 0.0, 0.0, 0.1)
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
    self.psychokinetic = false;
    self.teleport = false;
    self.fly = false;
    self.power_run = false;
    self.blackhole = false;
    self.ped = nil;
    self.entitys = {}
    o(self)
end;
a:registerClass()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        collectgarbage()
    end
end)
