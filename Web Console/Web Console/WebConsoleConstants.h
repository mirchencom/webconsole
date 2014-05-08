//
//  WebConsoleConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//


#pragma mark - Preferences Defaults

#define kUserDefaultsFilename @"UserDefaults"
#define kUserDefaultsFileExtension @"plist"

#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"
 

#pragma mark - AppleScript Arguments Dictionary

#define kAppleScriptTargetKey @"Target"
#define kBaseURLKey @"BaseURL"
#define kArgumentsKey @"Arguments"
#define kDirectoryKey @"Directory"
#define kTextKey @"Text"


#pragma mark - Plugins

#define kPlugInExtension @"wcplugin"
#define kSharedResourcesPluginName @"Shared Resources"
#define kPlugInsPathComponent @"PlugIns"

#pragma mark - Environment

#define kEnvironmentDictionaryKey @"environmentDictionary"
#define kEnvironmentVariableWindowIDKey @"WC_WINDOW_ID"
#define kEnvironmentVariablePluginNameKey @"WC_PLUGIN_NAME"
#define kEnvironmentVariableSharedResourcesPathKey @"WC_SHARED_RESOURCES_PATH"
#define kEnvironmentVariableSharedResourcesURLKey @"WC_SHARED_RESOURCES_URL"


#pragma mark - Timeouts

#define kTaskInterruptTimeout 1.0
#define kApplicationTerminationTimeout 60.0