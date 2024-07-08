-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}
local utils = require("utils")

-- local function googleOneVPNOff()
--     local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
--     t:start()
-- end

local pureVPNApp = utils:appID("/Applications/PureVPN.app")

local function maybeKillPureVPN()
    local a = hs.application.get(pureVPNApp)
    if a ~= nil then
        a:kill9()
        hs.timer.waitUntil(function() 
            if hs.application.get(pureVPNApp) == nil then 
                return true
            else
                return false
            end
        end, function(timer)
            hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "7847D419-2363-4F3B-BE31-F677A4E707FF"}):start()
        end)
    end
end

local function decaffeinate()
    spoon.Caffeine:setState(false)
end

local function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        -- googleOneVPNOff()
        --pureVPNOff()
        decaffeinate()
        maybeKillPureVPN()
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module