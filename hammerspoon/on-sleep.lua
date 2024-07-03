-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}

-- local function googleOneVPNOff()
--     local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
--     t:start()
-- end

local function stopVPN(id)
    local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", id})
    t:start()
end

local function decaffeinate()
    spoon.Caffeine:setState(false)
end

local googleOneVPNId = "48797392-C894-4002-BD1E-16308CC9FC97"
local pureVPNId = "7847D419-2363-4F3B-BE31-F677A4E707FF"

local function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        -- googleOneVPNOff()
        stopVPN(pureVPNId)
        decaffeinate()
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module