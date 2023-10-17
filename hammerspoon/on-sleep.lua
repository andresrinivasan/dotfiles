-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

require "string"

function googleOneVPNOff()
    local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
    t:start()
end

function f(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        googleOneVPNOff()
    end
end

watcher = hs.caffeinate.watcher.new(f)
watcher:start()