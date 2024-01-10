-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}

-- function sleep(n)
--     local t0 = os.clock()
--     while clock() - t0 <= n do end
-- end

function module:healthCheckApp(a)
    return function()
        print(a)
        if hs.application.get(a:title()) == nil then
            return false
        else
            return true
        end
    end
end

function module:launchApp(hint)
    return function(timer)
        local a = hs.application.open("Toggl Track", 0, true)
        print(a)
        hs.timer.waitUntil(module.healthCheckApp(a), module.hideApp(a))
    end
end

function module:hideApp(a)
    return function(timer)
        print("hideApp")
        a:focusedWindow():close()
    end
end

function module:maybeRestartTogglTrack()
    local a = hs.application.get("Toggl Track")
    if a ~= nil then
        a:kill9()
        hs.timer.waitWhile(module.healthCheckApp("Toggl Track"), module.launchApp("Toggl Track"))
    end
end
    
local function f(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        module.maybeRestartTogglTrack()
    end
end

-- module.watcher = hs.caffeinate.watcher.new(f)
-- module.watcher:start()

return module