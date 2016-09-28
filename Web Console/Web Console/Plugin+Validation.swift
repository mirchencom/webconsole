//
//  Plugin+Validation.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/27/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation

extension Plugin {
    func renameWithUniqueName() {
        let newName = type(of: self).uniquePluginName(fromName: name, for: self)
        name = newName!
    }
}
