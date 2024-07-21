-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}
local utils = require("utils")

-- local function googleOneVPNOff()
--     local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
--     t:start()
-- end

local function maybeKillPureVPN()
    utils:maybeKillApp(utils:appID("/Applications/PureVPN.app"), function(timer)
        hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "7847D419-2363-4F3B-BE31-F677A4E707FF"}):start()
    end)
end

local function maybeKillZoom()
    utils:maybeKillApp(utils:appID("/Applications/zoom.us.app"))
end

local function maybeKillFathom()
    local hint = utils:appID("/Applications/Fathom.app")
    utils:maybeKillApp(hint, function(timer)
        hs.application.launchOrFocusByBundleID(hint)
    end)
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
        maybeKillZoom()
        maybeKillFathom()
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module