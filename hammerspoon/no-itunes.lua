local module = {}

local function appEvent(name, event, app)
  if name == "Music" and event == hs.application.watcher.launching then
    app:hide()
    app:kill()
    hs.notify.show("No iTunes", "Killed iTunes/Music", "")
  end
end

module.appWatch = hs.application.watcher.new(appEvent)
module.appWatch:start()

return module
