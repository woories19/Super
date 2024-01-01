local isHtmlBoxVisible = false

function UI()
    isHtmlBoxVisible = not isHtmlBoxVisible
    SendNUIMessage({
        type = "toggleHtmlBox",
        isVisible = isHtmlBoxVisible
    })
end
function UI2()
    isHtmlBoxVisible = not isHtmlBoxVisible
    SendNUIMessage({
        type = "toggleHtmlBox2",
        isVisible = isHtmlBoxVisible
    })
end
function UI3()
    isHtmlBoxVisible = not isHtmlBoxVisible
    SendNUIMessage({
        type = "toggleHtmlBox3",
        isVisible = isHtmlBoxVisible
    })
end
function UI4()
    isHtmlBoxVisible = not isHtmlBoxVisible
    SendNUIMessage({
        type = "toggleHtmlBox4",
        isVisible = isHtmlBoxVisible
    })
end

AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    SendNUIMessage({
        type = "initHtmlBox"
    })
end)
