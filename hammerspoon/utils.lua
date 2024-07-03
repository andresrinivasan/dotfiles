-- From https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua

local module = {}

-- Returns the bundle ID of an application, given its path.
function module:appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end

return module