//
//  MotifTestThemes.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation
@testable import MotifKit

enum TestEnumType: Int {
    case one
    case two
    case three
    case four
}

class TestObjectClass: NSObject {
    var data: String = "stuff"
    var attribute = [String: AnyObject]()
    var enumerator = TestEnumType.one
    
    override func setValue(_ value: Any?, forKey key: String) {
        if(value == nil) {
            return
        }
        
        switch key {
            case "enumerator":
                enumerator = TestEnumType(rawValue: value as! Int)!
                break
            case "data":
                data = value as! String
                break
            case "attribute":
                attribute = value as! [String: AnyObject]
                break
            default:
                break
        }
    }
}

struct DarkTheme: MotifTheme {
    let classes: [MotifClass] = [Default(), MotifKitTests()]
    
    struct Default: MotifClass {
        let TestDefaultColor = UIColor.purple
    }
    
    struct MotifKitTests: MotifClass {
        let TestColor = UIColor.green
        let TestFont = UIFont(name: "Avenir", size: 1)
        let TestFont2 = UIFont(name: "Avenir-BlackOblique", size: 1)
        let TestAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.cyan,
            NSFontAttributeName : UIFont(name: "Avenir-BlackOblique", size: 15)!
        ]
        let TestEnum = TestEnumType.two
        let TestObject = TestObjectClass()
        let TestString = "Testing"
        
        let String1 = "This is a string"
        let String2 =  "So is this"
        let String3 = "and this is too"
    }
}

struct LightTheme: MotifTheme {
    let classes: [MotifClass] = [Default(), MotifKitTests()]
    
    struct Default: MotifClass {
        let TestDefaultColor = UIColor.purple
    }
    
    struct MotifKitTests: MotifClass {
        let TestColor = UIColor.blue
    }
}


public func ==(lhs: [String: AnyObject], rhs: [String: AnyObject] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
