-- From https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua

local module = {}

-- Returns the bundle ID of an application, given its path.
function module:appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end

-- Assumes sudo doesn't require a password for renice
--
-- Eg. 
-- ALL ALL = NOPASSWD: /usr/bin/renice

local function doRenice(nice)
  return function(exitCode, stdOut, stdErr)
      local n = tostring(nice)
      local p = string.gsub(stdOut, "%s+", "")
      hs.task.new("/usr/bin/sudo", nil, {"/usr/bin/renice", n, p}):start()
  end
end

function module:renice(name, nice)
  hs.task.new("/usr/bin/pgrep", doRenice(nice), {name}):start()
end

function module:maybeKillApp(appBundle, postKill, timeout)
  local postKill = postKill or function(timer) return end
  local timeout = timeout or 5

  local a = hs.application.get(appBundle)

  if a ~= nil then
      a:kill()
      local t = hs.timer.waitUntil(function() 
          a = hs.application.get(appBundle)
          if a == nil then 
              return true
          else
              a:kill9()
              return false
          end
      end, postKill)
      hs.timer.doAfter(timeout, function()
        if t:running() then
          t:stop()
          hs.notify.show(a:title(), "", "I should have shutdown but I did not stop")
        end
      end)
  end
end

return module