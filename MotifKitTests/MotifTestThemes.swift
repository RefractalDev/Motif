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
    struct TestMenu {
        static let TextColor = UIColor.greenColor()
    }
}

struct LightTheme: MotifTheme {
    struct TestMenu {
        static let TextColor = UIColor.blueColor()
    }
}