//
//  MotifError.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

public enum MotifError: ErrorType {
    // We only support structs
    case StructRequired
    // The entity does not exist in the struct
    case UnknownEntity(name: String, theme: String)
    // The entity does not contain a default data class
    case NoDefaultClass
    // There is no currently loaded template
    case NoLoadedTemplate
    // The provided key cannot be found in any theme class
    case InvalidKey(name: String)
}