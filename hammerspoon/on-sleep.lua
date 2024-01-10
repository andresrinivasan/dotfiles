-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}

local function googleOneVPNOff()
    local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
    t:start()
end

local function decaffeinate()
    spoon.Caffeine:setState(false)
end

local function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        googleOneVPNOff()
        decaffeinate()
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module