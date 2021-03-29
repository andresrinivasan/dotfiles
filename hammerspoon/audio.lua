local builtinIn = hs.audiodevice.findInputByName("Built-in Microphone")
local builtinOut = hs.audiodevice.findOutputByName("Built-in Output")
local link370In = hs.audiodevice.findInputByName("Jabra Link 370")
local link370Out = hs.audiodevice.findOutputByName("Jabra Link 370")

local function setDefaultAudioDevice(deviceIn, deviceOut)
  if deviceIn:setDefaultInputDevice() and deviceOut:setDefaultOutputDevice() then
    status = "Succeeded"
  else
    status = "FAILED"
  end

  hs.notify.show("Audio", string.format("Switching to %s...", deviceIn:name()), status)
end

-- function audioDeviceChanged(arg)
--   useBuiltinMic(arg)
--   -- resetBalance(arg)
-- end

-- -- Based on https://github.com/srubin/hammersteve
-- -- Use Mac microphone when switching to Bluetooth audio
-- function useBuiltinMic(arg)
--   if hs.audiodevice.current(true)["device"]:transportType() == "Bluetooth" then
--     builtinMic:setDefaultInputDevice()
--   end
-- end


-- hs.audiodevice.watcher.setCallback(audioDeviceChanged)
-- hs.audiodevice.watcher.start()

-- function audiowatch(arg)
--   print(string.format("Audiowatch arg: %s", arg))
-- end

-- hs.audiodevice.watcher.setCallback(audiowatch)
-- hs.audiodevice.watcher.start()

-- Inspired by https://www.tunabellysoftware.com/balance_lock/
local function resetBalance(uid, event, scope, element)
  print(event)
  if event == "span" then
    device = hs.audiodevice.findDeviceByUID(uid)
    if device:balance() ~= 0.5 then
      device:setBalance(0.5)
    end
  end
end

audioWatcher = {}
local audio = function() 
  for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
    audioWatcher[dev:name()] = dev:watcherCallback(resetBalance):watcherStart()
    print(dev:watcherIsRunning())
  end
  
  for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
    print(dev:watcherIsRunning())
  end
  
  hs.hotkey.bind(ctrl_opt, "f7", function()
    setDefaultAudioDevice(link370In, link370Out)
  end)
  
  hs.hotkey.bind(ctrl_opt, "f8", function()
    hs.notify.show("Audio", "Default audio device", hs.audiodevice.defaultInputDevice():name())
  end)
  
  hs.hotkey.bind(ctrl_opt, "f9", function()
    setDefaultAudioDevice(builtinIn, builtinOut)
  end)
end
audio()

return audio