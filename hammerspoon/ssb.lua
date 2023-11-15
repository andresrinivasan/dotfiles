-- From https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua

-- Returns the bundle ID of an application, given its path.
function appID(app)
    if hs.application.infoForBundlePath(app) then
      return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end

-- Returns a function that takes a URL and opens it in the given Chrome profile
-- Note: the value of `profile` must be the name of the profile directory under
-- ~/Library/Application Support/Google/Chrome/
function chromeProfile(profile)
    return function(url)
      hs.task.new("/usr/bin/open", nil, { "-n",
                                          "-a", "Google Chrome",
                                          "--args",
                                          "--profile-directory="..profile,
                                          url }):start()
    end
end

function braveProfile(profile)
    return function(url)
      hs.task.new("/usr/bin/open", nil, { "-n",
                                          "-a", "Brave Browser",
                                          "--args",
                                          "--profile-directory="..profile,
                                          url }):start()
    end
end

-- Define the IDs of the various applications used to open URLs
chromeBrowser  = appID('/Applications/Google Chrome.app')
braveBrowser   = appID('/Applications/Brave Browser.app')
safariBrowser  = appID('/Applications/Safari.app')
googleMeet = appID('/Users/andre/Applications/Brave Browser Apps.localized/Google Meet.app')

-- Define my default browsers for various purposes
browsers = {
    braveDefault = braveProfile("Default"),
    braveIOTech = braveProfile("Profile 2"),
    chromeDefault = chromeProfile("Default")
}

Install:andUse("URLDispatcher", {
    config = {
        default_handler = browsers.braveDefault,
        set_system_handler = false --,
        -- url_patterns = {
        --     {"https://meet%.google%.com/", googleMeet}
        -- }
    },
    start = true,
    loglevel = 'debug',
})
