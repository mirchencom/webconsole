//
//  PluginInitializationTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest
@testable import Web_Console

class PluginInitializationTests: WCLTestPluginManagerTestCase {

//    func testHelloWorldPlugin() {
//        
//    }
    
    func testLogPlugin() {
        let logPlugin = PluginsManager.sharedInstance.pluginWithName(testLogPluginName)
        // TODO test properties
    }


}
