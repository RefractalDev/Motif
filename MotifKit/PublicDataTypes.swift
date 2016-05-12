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

// This enum handles all of our Error types and general throws
// This allows us to quickly and efficiently provide error data while conforming to Swift 2's error handling

public enum MotifError: ErrorType {
    // We only support structs
    case StructRequired
    // The class does not exist in the struct
    case MissingClassDefinition(name: String)
    // The entity does not contain a default data class
    case NoDefaultClass
    // There is no currently loaded template
    case NoLoadedTemplate
    // The provided key cannot be found in any theme class
    case InvalidKey(name: String)
    // The provided object does not match the type defined
    case TypeMismatch(name: String, type: String)
}