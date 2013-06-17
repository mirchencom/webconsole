#!/usr/bin/osascript

tell application "Safari"
	do shell script "echo " & quoted form of (class of front document as text)
	-- front document
end tell
