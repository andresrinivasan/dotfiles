-- From https://gist.github.com/ysimonson/fea48ee8a68ed2cbac12473e87134f58

local module = {}

-- function sleep(n)
--     local t0 = os.clock()
--     while clock() - t0 <= n do end
-- end

local utils = require("utils")

local togglTrackApp = utils:appID("/Applications/Toggl Track.app")

-- Suppress warning about Spotlight
hs.application.enableSpotlightForNameSearches(false)

local function healthCheckApp(hint, checkWindow)
    return function()
        if hs.application.get(hint) == nil then
            return false
        elseif checkWindow and hs.application.get(hint):focusedWindow() == nil then
            return false
        else
            return true
        end
    end
end

local function hideApp(hint)
    return function(timer)
        hs.application.get(hint):focusedWindow():close()
    end
end

local function launchApp(hint)
    return function(timer)
        hs.application.launchOrFocusByBundleID(hint)
        hs.timer.waitUntil(healthCheckApp(hint, true), hideApp(hint))
    end
end

local function maybeRestartTogglTrack()
    local a = hs.application.get(togglTrackApp)
    if a ~= nil then
        a:kill9()
        hs.timer.waitWhile(healthCheckApp(togglTrackApp, false), launchApp(togglTrackApp))
    end
end

-- Assumes sudo doesn't require a password for renice
--
-- Eg. 
-- ALL ALL = NOPASSWD: /usr/bin/renice

local function pgrep(exitCode, stdOut, stdErr)
    local p = string.gsub(stdOut, "%s+", "")
    local t = hs.task.new("/usr/bin/sudo", nil, {"/usr/bin/renice", "20", p})
    t:start()
end

local function renice(name)
    local t = hs.task.new("/usr/bin/pgrep", pgrep, {name})
    t:start()
end
    
local function f(event)
    if event == hs.caffeinate.watcher.systemDidWake then
        maybeRestartTogglTrack()
        renice("crowdstrike")
    end
end

module.watcher = hs.caffeinate.watcher.new(f)
module.watcher:start()

return module