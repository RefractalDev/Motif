//
//  MotifUtils.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 03/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

class Utils {
    class func parseTheme(theme: MotifTheme) throws -> (String, ThemeData) {
        // First, get the theme name
        let themeName = String(theme.dynamicType)
        
        // Reflect the theme so we can manipulate it
        let theme = Mirror(reflecting: theme)
        
        // Make sure we're analyzing a struct
        guard theme.displayStyle == .Struct else { throw MotifError.StructRequired }
        
        // Get the index of our classes array
        let classesIndex = theme.children.indexOf({ child in
            return child.label == "classes"
        })
        
        // Now, extract our classes array and start to parse it
        let classesArray = theme.children[classesIndex!].value as! [MotifClass]
        var finalClassesArray = ThemeData()
        
        for (themeClass) in classesArray {
            let className = String(themeClass.dynamicType)
            let classMirror = Mirror(reflecting: themeClass)
            
            var classProperties = [String: Any]()
            
            // Interate through our object properties
            for (label, value) in classMirror.children {
                // If the property has a value and a label we're good
                if let propertyName = label {
                    classProperties[propertyName] = value
                }
            }
            // Set the class properties for the class
            finalClassesArray[className] = classProperties
        }
        
        // Double check we have a Default object
        guard finalClassesArray.keys.contains("Default") else { throw MotifError.NoDefaultClass }
        
        // And finally return all our data
        return (themeName, finalClassesArray)
    }
    
    class func getRelevantObject<T>(file: String, key: String) throws -> T {
        // First, get our current theme name
        guard let currentThemeKey = Motif.sharedInstance.currentTheme else { throw MotifError.NoLoadedTemplate }
        
        // Second, acquire its index in the stack
        let currentThemeIndex = Motif.sharedInstance.themes.indexOf({ object in
            return object.name == currentThemeKey
        })
        
        // Third, acquire the actual object
        let currentTheme = Motif.sharedInstance.themes[currentThemeIndex!].data
        
        // Then check the Class-specific data
        let classData: [String: Any]? = currentTheme[file]
        // Second, check the generic data..
        let defaultData: [String: Any]? = currentTheme["Default"]
        
        var objectData: Any?
        
        // Finally, check both sets for a matching key
        if (classData != nil) {
            objectData = classData![key]
        }
        
        if (defaultData != nil && objectData == nil) {
            objectData = defaultData![key]
        }
        
        // If there's no match, and you don't have a class definition, throw a missing class error
        if (objectData == nil && classData == nil) {
            throw MotifError.MissingClassDefinition(name: file)
        }
        
        // If we don't match either, throw an invalid key error
        guard (objectData != nil) else { throw MotifError.InvalidKey(name: key) }

        /// If our given type doesn't match, then return an error
        guard objectData is T else { throw MotifError.TypeMismatch(name: key, type: String(T.self)) }
        
        // And then return our lovely value
        return objectData as! T
    }
}