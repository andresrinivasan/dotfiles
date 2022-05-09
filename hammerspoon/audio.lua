BUILTIN_AUDIO="Built-in"

useWiredHeadset = false

builtinIn = hs.audiodevice.findInputByName("MacBook Pro Microphone")
builtinOut = hs.audiodevice.findOutputByName("MacBook Pro Speakers")
link370In = hs.audiodevice.findInputByName("Jabra Link 370")
link370Out = hs.audiodevice.findOutputByName("Jabra Link 370")

function setAlwaysUseWiredHeadset()
  useWiredHeadset = true
end

function setDefaultAudioDevice(deviceIn, deviceOut)
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

-- Inspired by https://www.tunabellysoftware.com/balance_lock/
local function resetBalance(uid, event, scope, element)
  if event == "span" or event == "vmvc" then    -- XXX Span should be sufficient per the docs
    device = hs.audiodevice.findDeviceByUID(uid)
    if device:balance() ~= 0.5 then
      device:setBalance(0.5)
    end
  end
end

local function selectJack(uid, event, scope, element)
  if event == "jack" and builtinIn:jackConnected() and useWiredHeadset then
      setDefaultAudioDevice(builtinIn, builtinOut)
    end
end

builtinIn:watcherCallback(selectJack)
builtinIn:watcherStart()

local function notifyDefaultAudio()
  hs.notify.show("Audio", "Default audio device", hs.audiodevice.defaultInputDevice():name())
end

for i,d in ipairs(hs.audiodevice.allOutputDevices()) do
  d:watcherCallback(resetBalance)
  d:watcherStart()
  print(d:watcherIsRunning())
end

for i,d in ipairs(hs.audiodevice.allOutputDevices()) do   -- XXX Bug. Prints false.
  print(d:watcherIsRunning())
end


