-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}

-- function sleep(n)
--     local t0 = os.clock()
--     while clock() - t0 <= n do end
-- end

local utils = require("utils")

local function hideApp(hint)
    return function(timer)
        hs.application.get(hint):focusedWindow():close()
    end
end

local function launchApp(hint)
    return function(timer)
        hs.application.launchOrFocusByBundleID(hint)
        hs.application.get(hint):hide()
        hs.timer.doAfter(3, function() 
            hs.timer.waitUntil(function()
                if hs.application.get(hint) ~= nil and hs.application.get(hint):focusedWindow() ~= nil then
                    return true
                else
                    return false
                end
            end, function(timer)
                hs.application.get(hint):focusedWindow():close()
            end)
        end)
    end
end

local function maybeRestartTogglTrack()
    utils:maybeKillApp(id, launchApp(utils:appID("/Applications/Toggl Track.app")))
end
    
local function f(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        maybeRestartTogglTrack()
        utils:renice("crowdstrike", 20)
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module