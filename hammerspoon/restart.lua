require('utils')

local module = {}

module.toggl  = appID('/Applications/Toggl Track.app')
module.fathom  = appID('/Applications/Fathom.app')

function module:restart() 
    local app, w

    for k, v in paris(module.apps) do
        app = hs.application.get(v)
        if app ~= nil then
            app:kill9()
            app = hs.application.open(v, 5, true)
            w = app:allWindows()
            for i = 1, #w do
                w[i]:close()
            end
        end
    end
end

function module:addApp(app)
    module.apps[app] = appID(app)
    return module.apps[app]
end

function module:maybeRestart()
end


-- hs.urlevent.bind("restart", function(eventName, params)
--     module:restart()
-- end)

return module
