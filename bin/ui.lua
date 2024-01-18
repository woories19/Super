local nuiDrawn = false
local permsCalculated = false
local perms = {'0', '0', '0', '0', '0'}

function calPerms()
    if not permsCalculated then
        permsCalculated = true
        if player.isAce then
            if player.aceFly then
                perms[1] = '1'
            end
            if player.aceRun then
                perms[2] = '1'
            end
            if player.aceVision then
                perms[3] = '1'
            end
            if player.aceGrab then
                perms[4] = '1'
            end
            if player.aceRas then
                perms[5] = '1'
            end
        end
    end
end

function superUI()
    calPerms()
    nuiDrawn = not nuiDrawn
    SendNUIMessage({
        type = perms;
        isVisible = nuiDrawn
    })
end

--[[ 
AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    SendNUIMessage({
        type = "initHtmlBox"
    })
end)
 ]]