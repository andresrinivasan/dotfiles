-- Better format-less pasting and bypass JavaScript field pasting blocks
hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

local function replaceQuotes(s) 
end

watcher = hs.pasteboard.watcher.new(replaceQuotes)
watcher:start()