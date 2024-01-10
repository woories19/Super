-- A Lua Script for all the base functions needed for the scripts to function
-- Organized in a single file
-- by maardiyamujhay

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

function castRay( coordFrom, coordTo )
    local rayHandle = StartShapeTestLosProbe( coordFrom.x, coordFrom.y, coordFrom.z - 0.3, coordTo.x, coordTo.y, coordTo.z, 4294967295, GetPlayerPed( -1 ), 4 )
    local _, hit, endCoords, _, entity = GetRaycastResult( rayHandle )
    return entity
end

function chat(str)
    TriggerEvent('chat:addMessage', {
        color = {255,255,255},
        multiline = true,
        args = {"System", str}
    })
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    
    while not HasAnimDictLoaded(dict) do
      Wait(500)
    end
end