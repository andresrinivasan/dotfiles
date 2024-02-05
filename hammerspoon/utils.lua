-- From https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua

-- Returns the bundle ID of an application, given its path.
function appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end