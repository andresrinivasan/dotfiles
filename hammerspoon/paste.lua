-- Better format-less pasting and bypass JavaScript field pasting blocks

local module = {}

hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

local function replaceQuotes(s) 
end

module.watcher = hs.pasteboard.watcher.new(replaceQuotes)
module.watcher:start()

return module