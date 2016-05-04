//
//  MotifTheme.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

// This will be our main protocol all Themes have to conform to.
// Most other info is up to the user, but at a minimum we should have a defined name

public protocol MotifTheme {
    var classes: [MotifClass] { get }
}

// This protocol is what all our individual class data structs will conform to
// This allows us to iterate and store these classes without weirdness in typecasting

public protocol MotifClass {
    
}