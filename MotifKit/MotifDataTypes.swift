//
//  MotifDataTypes.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 03/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

// These types are used to define and store the types of information Motif can handle

// [Class: [Item: Value]]
typealias ThemeData = [String: [String: Any]]

// This event is called to update our variables
typealias UpdateEvent = () -> Void

// Wrap our basic parsed theme info in a Hashable struct to store in a Set
struct ParsedTheme: Hashable {
    var name: String
    var data: ThemeData
    
    init(_ tuple: (name: String, data: ThemeData))  {
        name = tuple.name
        data = tuple.data
    }
    
    var hashValue: Int {
        return self.name.hashValue
    }
}

func ==(lhs: ParsedTheme, rhs: ParsedTheme) -> Bool {
    return lhs.name == rhs.name
}