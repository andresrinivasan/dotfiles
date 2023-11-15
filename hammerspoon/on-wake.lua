-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

function googleOneVPNOff()
    local t = hs.task.new("/usr/sbin/scutil", nil, {"--nc", "stop", "48797392-C894-4002-BD1E-16308CC9FC97"})
    t:start()
end

-- function sleep(n)
--     local t0 = os.clock()
--     while clock() - t0 <= n do end
-- end

function healthCheckApp(hint)
    return function()
        if hs.application.get(hint) == nil then
            return false
        else
            return true
        end
    end
end

function launchApp(hint)
    return function(timer)
        hs.application.open("Toggl Track")
        hs.timer.waitUntil(healthCheckApp("Toggl Track"), hideApp("Toggl Track"))
    end
end

function hideApp(hint)
    return function(timer)
        hs.application.get(hint):hide()
    end
end

function maybeRestartTogglTrack()
    local a = hs.application.get("Toggl Track")
    if a ~= nil then
        a:kill9()
        hs.timer.waitWhile(healthCheckApp("Toggl Track"), launchApp("Toggl Track"))

    end
end
    
function f(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        maybeRestartTogglTrack()
    end
end

-- watcher = hs.caffeinate.watcher.new(f)
-- watcher:start()