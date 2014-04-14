//
//  WebConsoleConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//


#pragma mark - Preferences Defaults

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


#pragma mark - Environment

#define kEnvironmentDictionaryKey @"environmentDictionary"

#define kEnvironmentVariablePathKey @"PATH"
#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";
#define kEnvironmentVariableWindowIDKey @"WC_WINDOW_ID"
#define kEnvironmentVariableSharedResourcePathKey @"WC_SHARED_RESOURCE_PATH"
#define kEnvironmentVariableSharedResourceURLKey @"WC_SHARED_RESOURCE_URL"
#define kEnvironmentVariableEncodingKey @"LC_ALL" 
#define kEnvironmentVariableEncodingValue @"en_US.UTF-8"


#pragma mark - Timeouts

#define kTaskInterruptTimeout 1.0
#define kApplicationTerminationTimeout 60.0