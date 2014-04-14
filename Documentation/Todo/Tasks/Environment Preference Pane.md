# Environment Preference Pane

* [ ] Test if I can migrate this to defaults too:

	    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];

* [ ] Delete `NSUserDefaults`, `defaults delete com.1percenter.Web-Console`
* [ ] Write a test for `WebKitDeveloperExtras`?
* [ ] Add it to the `UserDefaults.plist`
* [ ] See if I can use the Web Inspector

## Notes

	<key>WebKitDeveloperExtras</key>
	<true/>
