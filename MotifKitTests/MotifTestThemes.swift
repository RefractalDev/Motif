//
//  MotifTestThemes.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation
@testable import MotifKit

struct DarkTheme: MotifTheme {
    let classes: [MotifClass] = [TestMenu()]
    
    struct TestMenu: MotifClass {
        let TextColor = UIColor.greenColor()
    }
}

struct LightTheme: MotifTheme {
    let classes: [MotifClass] = [TestMenu()]
    
    struct TestMenu: MotifClass {
        let TextColor = UIColor.blueColor()
    }
}