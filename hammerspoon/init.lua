hs.logger.defaultLogLevel = "info"

hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}
ctrl_opt    = {"ctrl","alt"}
shift_ctrl_opt = {"ctrl", "alt", "shift"}

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

Install:andUse("Caffeine")
spoon.Caffeine:bindHotkeys({toggle = {shift_ctrl_opt, "w"}})
spoon.Caffeine:start()

Install:andUse("MiroWindowsManager")
hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
  up = {ctrl_opt, "up"},
  right = {ctrl_opt, "right"},
  down = {ctrl_opt, "down"},
  left = {ctrl_opt, "left"},
  fullscreen = {ctrl_opt, "return"}
})

hs.hotkey.bind(ctrl_opt, "z", function()
  hs.window("Zoom Meeting"):focus():raise()
end)

-- Install:andUse("Seal",
--   {
--     hotkeys = {
--         show = { ctrl_cmd, "Space" }
--     },
--     fn = function(s)
--         s:loadPlugins({"apps", "vpn", "screencapture", "safari_bookmarks", "calc", "useractions", "pasteboard"})
--         s.plugins.pasteboard.historySize=4000
--         s.plugins.useractions.actions = {
--             -- ["Red Hat Bugzilla"] = { url = "https://bugzilla.redhat.com/show_bug.cgi?id=${query}", icon="favicon", keyword="bz" },
--             -- ["Red Hat Support"] = { url = "https://access.redhat.com/support/cases/#/case/${query}", icon="favicon", keyword="sup" },
--             -- ["Red Hat Support Exception"] = { url = "https://tools.apps.cee.redhat.com/support-exceptions/id/${query}", icon="favicon", keyword="se" },
--             -- ["Launchpad Bugs"] = { url = "https://launchpad.net/bugs/${query}", icon="favicon", keyword="lp" },
--         }
--     end,
--     start = true
--   }
-- )

noitunes = require("no-itunes")

-- require("audio")
-- link370 = addPreferredAudio("Jabra Link", "Jabra Link 370", "Jabra Link 370")
-- builtIn = addPreferredAudio(BUILTIN_AUDIO)
-- setAlwaysUseWiredHeadset()

device = hs.audiodevice.findDeviceByName("MacBook Air Speakers")
-- print(device)
-- print(device:name())
-- print(device:balance())

-- -- From audio
-- -- Inspired by https://www.tunabellysoftware.com/balance_lock/
-- local function resetBalance(uid, event, scope, element)
--   print(string.format("resetBalance: event=%s, scope=%s, element=%d", event, scope, element))
--   if event == "span" or event == "vmvc" then    -- XXX span is returned for builtin. For BT I get vmvc.
--     device = hs.audiodevice.findDeviceByUID(uid)
--     print(string.format("resetBalance: device:name=%s device:balance=%f", device:name(), 0))
--     if device:balance() ~= 0.5 then
--       device:setBalance(0.5)
--     end
--   end
-- end

-- for i,d in ipairs(hs.audiodevice.allOutputDevices()) do
--   d:watcherCallback(resetBalance)
--   d:watcherStart()
-- end

hs.hotkey.bind(ctrl_opt, "F7", function()
  setDefaultAudioDevice(link370In, link370Out)
end)
hs.hotkey.bind(ctrl_opt, "F8", function()
  notifyDefaultAudio()
end)
hs.hotkey.bind(ctrl_opt, "F9", function()
  setDefaultAudioDevice(builtinIn, builtinOut)
end)

paste = require("paste")
onsleep = require("on-sleep")
onwake = require("on-wake")
-- ssb = require("ssb")
-- restart = require("restart")


-- Add $HOMEBREW_PREFIX/bin/hs REPL

if hs.fs.attributes("/opt/homebrew", "mode") then
  homebrew_prefix = "/opt/homebrew"
end
hs.ipc.cliInstall(homebrew_prefix)



