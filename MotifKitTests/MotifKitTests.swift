//
//  MotifKitTests.swift
//  MotifKitTests
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import XCTest
@testable import MotifKit

class MotifKitTests: XCTestCase {
    
    let fontToCompare = UIFont(name: "Avenir", size: 13.2)
    let attributesToCompare: [String : AnyObject] = [
        NSForegroundColorAttributeName: UIColor.cyan,
        NSFontAttributeName : UIFont(name: "Avenir-BlackOblique", size: 15)!
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        Motif.resetThemes()
        
        super.tearDown()
    }
    
    func testAddingTheme() {
        // Ensure there are no themes loaded initially
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getLoadedThemes().isEmpty)
        
        // Add a theme to the stack
        let result = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(result)
            
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getLoadedThemes(), ["DarkTheme"])
        
        // Wipe the theme
        Motif.resetThemes()
        
        // Check all themes are reset
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getLoadedThemes().isEmpty)
    }
    
    func testAddingThemes() {
        // Ensure there are no themes loaded initially
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getLoadedThemes().isEmpty)
        
        // Add a theme to the stack
        let firstResult = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(firstResult)
        
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getLoadedThemes(), ["DarkTheme"])
        
        // Add a second theme to the stack
        let secondResult = Motif.addTheme(LightTheme())
        
        XCTAssertTrue(secondResult)
        
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getLoadedThemes(), ["DarkTheme", "LightTheme"])
        
        // Wipe the theme
        Motif.resetThemes()
        
        // Check all themes are reset
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getLoadedThemes().isEmpty)
    }
    
    func testDuplicateThemes() {
        // Add a theme to the stack
        let firstResult = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(firstResult)
            
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getLoadedThemes(), ["DarkTheme"])
        
        // Then, add the same theme again
        let secondResult = Motif.addTheme(DarkTheme())
        
        XCTAssertFalse(secondResult)
            
        // Confirm no changes were made
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getLoadedThemes(), ["DarkTheme"])
    }
    
    func testGettingObjectsFromCompletion() {
        let expectations = [
            expectation(description: "TestColor should be Green"),
            expectation(description: "TestFont should be Avenir at 13.2pt"),
            expectation(description: "TestFont should be Avenir at 12pt, and TestFont2 should be AvenirBO at 20pt"),
            expectation(description: "TestAttributes should match our test set"),
            expectation(description: "TestObject should match the static data of TestObjectClass"),
            expectation(description: "TestEnum should match TestEnumType.Two"),
            expectation(description: "String1, String2, String3 should match 'This is a string', 'So is this' and 'this is too'")
        ]
        
        let firstResult = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(firstResult)
        
        Motif.set(color: "TestColor", completion: { color in
            // Confirm it matches
            XCTAssertEqual(color, UIColor.green)
            expectations[0].fulfill()
        })
        
        Motif.set(font: "TestFont", size: 13.2, completion: { font in
            let fontToCompare = UIFont(name: "Avenir", size: 13.2)
            
            XCTAssertEqual(font, fontToCompare)
            expectations[1].fulfill()
        })
        
        Motif.set(fonts: ["TestFont", "TestFont2"], sizes: [12, 22], completion: { fonts in
            let fontsToCompare = [UIFont(name: "Avenir", size: 12)!, UIFont(name: "Avenir-BlackOblique", size: 22)!]
            XCTAssertEqual(fonts, fontsToCompare)
            expectations[2].fulfill()
        })
        
        Motif.set(attribute: "TestAttributes", completion: { attributes in
            XCTAssertTrue(attributes == self.attributesToCompare)
            expectations[3].fulfill()
        })
        
        Motif.set(object: TestObjectClass.self, key: "TestObject", completion: { object in
            XCTAssertEqual(object.data, TestObjectClass().data)
            expectations[4].fulfill()
        })
        
        Motif.set(object: TestEnumType.self, key: "TestEnum", completion: { object in
            XCTAssertEqual(object, TestEnumType.two)
            expectations[5].fulfill()
        })
        
        Motif.set(objects: String.self, keys: ["String1", "String2", "String3"], completion: { strings in
            let compareTo = ["This is a string", "So is this", "and this is too"]
            
            XCTAssertEqual(strings, compareTo)
            expectations[6].fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testReloadingTheme() {
        let firstExpectation = expectation(description: "TestColor should be Green")
        let secondExpectation =  expectation(description: "TestColor should be Blue")
        var count = 0
        
        Motif.addTheme(DarkTheme())
        Motif.addTheme(LightTheme())
        
        Motif.set(color: "TestColor", completion: { color in
            // Confirm it matches
            if count > 0 {
                XCTAssertEqual(color, UIColor.blue)
                firstExpectation.fulfill()
            } else {
                XCTAssertEqual(color, UIColor.green)
                secondExpectation.fulfill()
            }
            
            count += 1
        })
        
        Motif.switchTo(theme: "LightTheme")
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSettingObjectsWithData() {
        
        let objectOne = UILabel(frame: CGRect.zero)
        let objectTwo = UILabel(frame: CGRect.zero)
        let dataObject = TestObjectClass()
        
        Motif.addTheme(DarkTheme())
        
        Motif.set(color: "TestColor", target: [objectOne, objectTwo], variable: "textColor")
    
        XCTAssertEqual(objectOne.textColor, UIColor.green)
        XCTAssertEqual(objectTwo.textColor, UIColor.green)
        
        Motif.set(font: "TestFont", target: objectOne, variable: "font", size: 13.2)
        
        XCTAssertEqual(objectOne.font, fontToCompare)
        
        Motif.set(attribute: "TestAttributes", target: dataObject, variable: "attribute")
        
        XCTAssertTrue(dataObject.attribute == attributesToCompare)
       
        Motif.set(enum: TestEnumType.self, key: "TestEnum", target: dataObject, variable: "enumerator")
        
        XCTAssertEqual(dataObject.enumerator, TestEnumType.two)
        
        Motif.set(object: String.self, key: "TestString", target: dataObject, variable: "data")
        
        XCTAssertEqual(dataObject.data, "Testing")
    }
    
    func testGettingDefaultObject() {
        Motif.addTheme(DarkTheme())
        
        Motif.set(color: "TestDefaultColor", completion: { color in
            // Confirm it matches
            XCTAssertEqual(color, UIColor.purple)
        })
    }
}
