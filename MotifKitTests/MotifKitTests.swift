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
        NSForegroundColorAttributeName: UIColor.cyanColor(),
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
        XCTAssertTrue(Motif.getThemes().isEmpty)
        
        // Add a theme to the stack
        let result = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(result)
            
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getThemes(), ["DarkTheme"])
        
        // Wipe the theme
        Motif.resetThemes()
        
        // Check all themes are reset
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getThemes().isEmpty)
    }
    
    func testAddingThemes() {
        // Ensure there are no themes loaded initially
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getThemes().isEmpty)
        
        // Add a theme to the stack
        let firstResult = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(firstResult)
        
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getThemes(), ["DarkTheme"])
        
        // Add a second theme to the stack
        let secondResult = Motif.addTheme(LightTheme())
        
        XCTAssertTrue(secondResult)
        
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getThemes(), ["LightTheme", "DarkTheme"])
        
        // Wipe the theme
        Motif.resetThemes()
        
        // Check all themes are reset
        XCTAssertNil(Motif.getCurrentTheme())
        XCTAssertTrue(Motif.getThemes().isEmpty)
    }
    
    func testDuplicateThemes() {
        // Add a theme to the stack
        let firstResult = Motif.addTheme(DarkTheme())
        
        XCTAssertTrue(firstResult)
            
        // Check the theme is loaded
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getThemes(), ["DarkTheme"])
        
        // Then, add the same theme again
        let secondResult = Motif.addTheme(DarkTheme())
        
        XCTAssertFalse(secondResult)
            
        // Confirm no changes were made
        XCTAssertEqual(Motif.getCurrentTheme(), "DarkTheme")
        XCTAssertEqual(Motif.getThemes(), ["DarkTheme"])
    }
    
    func testGettingObjectsFromCompletion() {
        let expectations = [
            expectationWithDescription("TestColor should be Green"),
            expectationWithDescription("TestFont should be Avenir at 13.2pt"),
            expectationWithDescription("TestFont should be Avenir at 12pt, and TestFont2 should be AvenirBO at 20pt"),
            expectationWithDescription("TestAttributes should match our test set"),
            expectationWithDescription("TestObject should match the static data of TestObjectClass"),
            expectationWithDescription("TestEnum should match TestEnumType.Two"),
            expectationWithDescription("String1, String2, String3 should match 'This is a string', 'So is this' and 'this is too'")
        ]
        
        Motif.addTheme(DarkTheme())
        
        Motif.setColor("TestColor", completion: { color in
            // Confirm it matches
            XCTAssertEqual(color, UIColor.greenColor())
            expectations[0].fulfill()
        })
        
        Motif.setFont("TestFont", size: 13.2, completion: { font in
            let fontToCompare = UIFont(name: "Avenir", size: 13.2)
            
            XCTAssertEqual(font, fontToCompare)
            expectations[1].fulfill()
        })
        
        Motif.setFonts(["TestFont", "TestFont2"], sizes: [12, 22], completion: { fonts in
            let fontsToCompare = [UIFont(name: "Avenir", size: 12)!, UIFont(name: "Avenir-BlackOblique", size: 22)!]
            XCTAssertEqual(fonts, fontsToCompare)
            expectations[2].fulfill()
        })
        
        Motif.setAttributes("TestAttributes", completion: { attributes in
            XCTAssertTrue(attributes == self.attributesToCompare)
            expectations[3].fulfill()
        })
        
        Motif.setObject(TestObjectClass.self, key: "TestObject", completion: { object in
            XCTAssertEqual(object.data, TestObjectClass().data)
            expectations[4].fulfill()
        })
        
        Motif.setObject(TestEnumType.self, key: "TestEnum", completion: { object in
            XCTAssertEqual(object, TestEnumType.Two)
            expectations[5].fulfill()
        })
        
        Motif.setObjects(String.self, keys: ["String1", "String2", "String3"], completion: { strings in
            let compareTo = ["This is a string", "So is this", "and this is too"]
            
            XCTAssertEqual(strings, compareTo)
            expectations[6].fulfill()
        })
        
        waitForExpectationsWithTimeout(2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testReloadingTheme() {
        let firstExpectation = expectationWithDescription("TestColor should be Green")
        let secondExpectation =  expectationWithDescription("TestColor should be Blue")
        var count = 0
        
        Motif.addTheme(DarkTheme())
        Motif.addTheme(LightTheme())
        
        Motif.setColor("TestColor", completion: { color in
            // Confirm it matches
            if count > 0 {
                XCTAssertEqual(color, UIColor.blueColor())
                firstExpectation.fulfill()
            } else {
                XCTAssertEqual(color, UIColor.greenColor())
                secondExpectation.fulfill()
            }
            
            count += 1
        })
        
        Motif.setTheme("LightTheme")
        
        waitForExpectationsWithTimeout(2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSettingObjectsWithData() {
        
        let objectOne = UILabel(frame: CGRectZero)
        let objectTwo = UILabel(frame: CGRectZero)
        let dataObject = TestObjectClass()
        
        Motif.addTheme(DarkTheme())
        
        Motif.setColor("TestColor", target: [objectOne, objectTwo], variable: "textColor")
    
        XCTAssertEqual(objectOne.textColor, UIColor.greenColor())
        XCTAssertEqual(objectTwo.textColor, UIColor.greenColor())
        
        Motif.setFont("TestFont", target: objectOne, variable: "font", size: 13.2)
        
        XCTAssertEqual(objectOne.font, fontToCompare)
        
        Motif.setAttributes("TestAttributes", target: dataObject, variable: "attribute")
        
        XCTAssertTrue(dataObject.attribute == attributesToCompare)
       
        Motif.setEnum(TestEnumType.self, key: "TestEnum", target: dataObject, variable: "enumerator")
        
        XCTAssertEqual(dataObject.enumerator, TestEnumType.Two)
        
        Motif.setObject(String.self, key: "TestString", target: dataObject, variable: "data")
        
        XCTAssertEqual(dataObject.data, "Testing")
    }
    
    func testGettingDefaultObject() {
        Motif.addTheme(DarkTheme())
        
        Motif.setColor("TestDefaultColor", completion: { color in
            // Confirm it matches
            XCTAssertEqual(color, UIColor.purpleColor())
        })
    }
}