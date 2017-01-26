//
//  XCTest+BundleResources.swift
//  FileSystem
//
//  Created by Roben Kleene on 10/1/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func pathForResource(name: String?, ofType ext: String?, inDirectory bundlePath: String) -> String? {
        return Bundle(for:type(of: self)).path(forResource: name, ofType:ext, inDirectory:bundlePath)
    }

    func URLForResource(name: String, withExtension ext: String?) -> URL? {
        return Bundle(for:type(of: self)).url(forResource: name, withExtension:ext)
    }
    
    func URLForResource(name: String, withExtension ext: String?, subdirectory subpath: String?) -> URL? {
        return Bundle(for:type(of: self)).url(forResource: name, withExtension:ext, subdirectory:subpath)
    }

    func stringWithContentsOfFileURL(fileURL: URL) -> String? {
        do {
            let contents = try NSString(contentsOf: fileURL, encoding: String.Encoding.utf8.rawValue)
            return contents as String
        } catch let error as NSError {
            XCTAssertNil(error)
        } catch {
            XCTAssertTrue(false)
        }
        return nil
    }

}
