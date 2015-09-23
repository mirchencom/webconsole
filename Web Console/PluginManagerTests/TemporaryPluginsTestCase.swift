//
//  TemporaryPluginsTestCase.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/8/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation
import XCTest

class TemporaryPluginsTestCase: TemporaryDirectoryTestCase {
    var pluginsDirectoryURL: NSURL!
    var pluginsDirectoryPath: String! {
        get {
            return pluginsDirectoryURL.path
        }
    }
    var pluginURL: NSURL!
    var pluginPath: String! {
        get {
            return pluginURL.path
        }
    }
    
    override func setUp() {
        super.setUp()
        
        // Create the plugins directory
        pluginsDirectoryURL = temporaryDirectoryURL
            .URLByAppendingPathComponent(pluginsDirectoryPathComponent)

        do {
            try NSFileManager
                .defaultManager()
                .createDirectoryAtURL(pluginsDirectoryURL,
                    withIntermediateDirectories: false,
                    attributes: nil)
        } catch let error as NSError {
            XCTAssertTrue(false, "Creating the directory should succeed \(error)")
        }
       
        // Copy the bundle resources plugin to the plugins directory
        let bundleResourcesPluginURL: NSURL! = URLForResource(testPluginName, withExtension:pluginFileExtension)
        let filename = testPluginName.stringByAppendingPathExtension(pluginFileExtension)!
        
        pluginURL = pluginsDirectoryURL.URLByAppendingPathComponent(filename)
        do {
            try NSFileManager
                .defaultManager()
                .copyItemAtURL(bundleResourcesPluginURL,
                    toURL: pluginURL)
        } catch let error as NSError {
            XCTAssertTrue(false, "Moving the directory should succeed \(error)")
        }
    }
    
    override func tearDown() {
        pluginsDirectoryURL = nil
        pluginURL = nil
        
        // Remove the plugins directory (containing the plugin)
        do {
            try removeTemporaryItemAtPathComponent(pluginsDirectoryPathComponent)
        } catch let error as NSError {
            XCTAssertTrue(false, "Removing the plugins directory should have succeeded \(error)")
        }
        
        super.tearDown()
    }
    
}