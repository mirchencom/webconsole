//
//  WebConsoleConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//


#define kAppName (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

#pragma mark - Preferences Defaults

#define kUserDefaultsFilename @"UserDefaults"
#define kUserDefaultsFileExtension @"plist"
#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"
#define kFileExtensionDefaultEnabled NO
#define kFileExtensionToPluginKey @"WCLFileExtensionToPlugin"
#define kFileExtensionEnabledKey @"enabled"
#define kFileExtensionPluginIdentifierKey @"pluginIdentifier"
#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"
#define kDebugModeEnabledKey @"WCLDebugModeEnabled"


#pragma mark - AppleScript Arguments Dictionary

#define kAppleScriptTargetKey @"Target"
#define kBaseURLKey @"BaseURL"
#define kArgumentsKey @"Arguments"
#define kDirectoryKey @"Directory"

#pragma mark - Plugins

#define kPlugInExtension @"wcplugin"
#define kLogPluginName @"Log"


#pragma mark - Plugins Manager Keys

#define kPluginsManagerPluginsKeyPath @"plugins"


#pragma mark - Environment

#define kEnvironmentDictionaryKey @"environmentDictionary"
#define kEnvironmentVariableWindowIDKey @"WC_WINDOW_ID"
#define kEnvironmentVariableSplitIDKey @"WC_SPLIT_ID"
#define kEnvironmentVariablePluginNameKey @"WC_PLUGIN_NAME"
#define kEnvironmentVariableSharedResourcesPathKey @"WC_SHARED_RESOURCES_PATH"
#define kEnvironmentVariableSharedResourcesURLKey @"WC_SHARED_RESOURCES_URL"


#pragma mark - Timeouts

#define kTaskInterruptTimeout 1.0
#define kApplicationTerminationTimeout 60.0


#pragma mark - Errors

#define kErrorDomain @"com.1percenter.Web-Console"
#define kErrorCodeInvalidPlugin -42


