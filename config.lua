superConfig = {}

--Refer to `https://docs.fivem.net/docs/game-references/controls/` if you want to change keybinds
superConfig.activate = 168 -- Convert to Superman = F7
superConfig.actUI = 'F7' -- Activate UI = F7
superConfig.run = 167 -- Enable Super Run = F6
superConfig.fly = 166 -- Enable Flight Mode = F5

superConfig.chatMsg = true -- to enable/disable the Chat Message when converting.
superConfig.invincibility = true -- to enable/disable invincibility when converted.






------- WHITELIST -------
-- add steam ids to whitelist
-- add steam ids exactly like the template shown below!!
-- flags available: 'run', 'fly', 'jump'
whitelist = {
    ['steam:000000000000000'] = {'run'},
    ['steam:000000000000001'] = {'run', 'fly'},
    ['steam:110000140ddcb5b'] = {'run', 'fly', 'jump'}, -- 'fridge_dev'
    ['steam:11000013c93b2a9'] = {'run', 'fly', 'jump'}, -- 'tom_dev'
    ['steam:11000013447b08a'] = {'run', 'fly', 'jump'}, -- 'jaadu_dev'
}