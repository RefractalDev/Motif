//
//  MotifUtils.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 03/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

class MotifUtils {
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
            
            var classProperties = [String: StoredType]()
            
            // Interate through our object properties
            for (label, value) in classMirror.children {
                // If the property has a value and a label we're good
                if let propertyName = label {
                    if value is StoredType {
                        classProperties[propertyName] = value as! StoredType
                    }
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
    
    class func getRelevantObject(file: String, key: String) throws -> StoredType {
        // First, get our current theme name
        guard let currentThemeKey = Motif.sharedInstance.currentTheme else { throw MotifError.NoLoadedTemplate }
        
        // Second, acquire its index in the stack
        let currentThemeIndex = Motif.sharedInstance.themes.indexOf({ object in
            return object.name == currentThemeKey
        })
        
        // Third, acquire the actual object
        let currentTheme = Motif.sharedInstance.themes[currentThemeIndex!].data
        
        guard (currentTheme[file] != nil) else { throw MotifError.UnknownEntity(name: key, theme: file) }
        
        // Then check the Class-specific data
        let classData = currentTheme[file]! as [String: StoredType]
        // Second, check the generic data..
        let defaultData = currentTheme["Default"]! as [String: StoredType]
        
        var objectData: StoredType?
        
        // Finally, check both sets for a matching key
        if (classData[key] != nil) {
            objectData = classData[key]
        } else if (defaultData[key] != nil) {
            objectData = defaultData[key]
        }
        
        // If we don't match either, throw an invalid key error
        guard (objectData != nil) else { throw MotifError.InvalidKey(name: key) }
        
        // And then return our lovely value
        return objectData!
    }
}