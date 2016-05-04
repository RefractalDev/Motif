//
//  MotifKit.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 01/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

public class Motif {
    // This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    // Setup our private variable stack
    static let sharedInstance = Motif()

    var currentTheme: String? = nil
    var themes = Set<ParsedTheme>()
    var updateEvents = [UpdateEvent]()
    
    public class func addTheme<T: MotifTheme>(theme: T) {
        // First, parse our theme class
        let parseData: (String, ThemeData)?
        let error: ErrorType?
        
        do {
            parseData = try MotifUtils.parseTheme(theme)
            error = nil
        } catch let thrownError {
            parseData = nil
            error = thrownError
        }
        
        // Double-check we don't have an invalid theme
        guard let parsedTheme: (name: String, data: ThemeData) = parseData else {
            return print("MotifKit Error: INVALID_THEME (\(error!))")
        }
        
        // First, store the theme
        sharedInstance.themes.insert(ParsedTheme(parsedTheme))
        
        // Second, set the default if we need to
        if sharedInstance.currentTheme == nil {
            sharedInstance.currentTheme = parsedTheme.name
        }
    }
    
    public class func getThemes() -> [String] {
        // Return a string list of the currently loaded themes
        return sharedInstance.themes.map({$0.name})
    }
    
    public class func getCurrentTheme() -> String {
        return (sharedInstance.currentTheme != nil) ? sharedInstance.currentTheme! : "None"
    }
    
    public class func resetThemes() {
        // Reset all our currently loaded themes
        sharedInstance.themes.removeAll()
        sharedInstance.currentTheme = nil
    }
    
    public class func setTheme(key: String) -> Bool {
        // If the theme doesn't exist, return false
        let containsTheme = sharedInstance.themes.contains({ object in
            return object.name == key
        })
        
        if !containsTheme {
            return false
        }
        
        // Otherwise, set the theme and update all views
        sharedInstance.currentTheme = key
        
        for event in sharedInstance.updateEvents {
            event()
        }
        
        return true
    }
    
    public class func setColor(passedClasses: [NSObject], variable: String, key: String, file: String = #file) {
        for passedClass in passedClasses {
            sharedInstance.setObject(key, file: file, completion: { object in
                passedClass.setValue(object as! UIColor, forKey: variable)
            })
        }
    }
    
    public class func setFont(passedClasses: [NSObject], variable: String, key: String, size: CGFloat, file: String = #file) {
        for passedClass in passedClasses {
            sharedInstance.setObject(key, file: file, completion: { object in
                passedClass.setValue((object as! UIFont).fontWithSize(size), forKey: variable)
            })
        }
    }
    
    public class func setAttributes(passedClasses: [NSObject], variable: String, key: String, file: String = #file) {
        for passedClass in passedClasses {
            sharedInstance.setObject(key, file: file, completion: { object in
                passedClass.setValue((object as! MotifAttributes).attributes, forKey: variable)
            })
        }
    }
    
    public class func setColor(passedClass: NSObject, variable: String, key: String, file: String = #file) {
        // Return the specified color
        sharedInstance.setObject(key, file: file, completion: { object in
            passedClass.setValue(object as! UIColor, forKey: variable)
        })
    }
    
    public class func setFont(passedClass: NSObject, variable: String, key: String, size: CGFloat, file: String = #file) {
        // Return the specified font, with our defined size
        sharedInstance.setObject(key, file: file, completion: { object in
            passedClass.setValue((object as! UIFont).fontWithSize(size), forKey: variable)
        })
    }
    
    public class func setAttributes(passedClass: NSObject, variable: String, key: String, file: String = #file) {
        sharedInstance.setObject(key, file: file, completion: { object in
            passedClass.setValue((object as! MotifAttributes).attributes, forKey: variable)
        })
    }
    
    public class func setColor(key: String, file: String = #file, completion: (UIColor) -> Void) {
        // Return the specified color
        sharedInstance.setObject(key, file: file, completion: { object in
            completion(object as! UIColor)
        })
    }

    public class func setFont(key: String, size: CGFloat, file: String = #file, completion: (UIFont) -> Void) {
        // Return the specified font, with our defined size
        sharedInstance.setObject(key, file: file, completion: { object in
            completion((object as! UIFont).fontWithSize(size))
        })
    }
    
    public class func setAttributes(key: String, file: String = #file, completion: ([String: AnyObject]) -> Void) {
        // Return our attributes list
        sharedInstance.setObject(key, file: file, completion: { object in
            completion((object as! MotifAttributes).attributes)
        })
    }
    
    private func setObject(key: String, file: String, completion: (StoredType) -> Void) {
        // Get the name of the calling class from its file path
        let className = (NSURL(string: file)!.URLByDeletingPathExtension?.lastPathComponent)!
        
        
        func applyObject() {
            do {
                let object = try MotifUtils.getRelevantObject(className, key: key)
                completion(object)
            } catch let error {
                print("MotifKit Error: SET_OBJECT (\(error))")
            }
        }
        
        // Initially set the object using our helper function
        applyObject()
        
        // And then add a handler to set the object and add it to our update event stack
        updateEvents.append({
            applyObject()
        })
    }

}