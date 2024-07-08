tell application "System Events"
	tell process "PureVPN"
		set frontmost to true
		click menu item "Quit PureVPN" of menu "PureVPN" of menu bar 1
	end tell
	keystroke return
end tell
