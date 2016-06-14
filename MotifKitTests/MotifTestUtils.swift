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
    case One
    case Two
    case Three
    case Four
}

class TestObjectClass: NSObject {
    var data: String = "stuff"
    var attribute = [String: AnyObject]()
    var enumerator = TestEnumType.One
    
    override func setValue(value: AnyObject?, forKey key: String) {
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
        let TestDefaultColor = UIColor.purpleColor()
    }
    
    struct MotifKitTests: MotifClass {
        let TestColor = UIColor.greenColor()
        let TestFont = UIFont(name: "Avenir", size: 1)
        let TestFont2 = UIFont(name: "Avenir-BlackOblique", size: 1)
        let TestAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.cyanColor(),
            NSFontAttributeName : UIFont(name: "Avenir-BlackOblique", size: 15)!
        ]
        let TestEnum = TestEnumType.Two
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
        
    }
    
    struct MotifKitTests: MotifClass {
        let TestColor = UIColor.blueColor()
    }
}


public func ==(lhs: [String: AnyObject], rhs: [String: AnyObject] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqualToDictionary(rhs)
}