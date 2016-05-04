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
typealias ThemeData = [String: [String: StoredType]]

// This event is called to update our variables
typealias UpdateEvent = () -> Void

// All allowed storable types must conform to this protocol
protocol StoredType {}

// In order to make our attributes conform to StoredType, we wrap them in a struct
public struct MotifAttributes {
    var attributes: [String: AnyObject]
    
    public init(_ attributes: [String: AnyObject]) {
        self.attributes = attributes
    }
}

// Wrap our basic parsed theme info in a Hashable struct to store in a Set
struct ParsedTheme: Hashable {
    var name: String
    var data: ThemeData
    
    var hashValue: Int {
        return self.name.hashValue
    }
}

func ==(lhs: ParsedTheme, rhs: ParsedTheme) -> Bool {
    return lhs.name == rhs.name
}

extension UIColor: StoredType {}
extension UIFont: StoredType {}
extension MotifAttributes: StoredType {}