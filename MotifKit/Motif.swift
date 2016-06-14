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
    
    public class func addTheme(theme: MotifTheme) -> Bool {
        // First, parse our theme class
        let parseData: (String, ThemeData)?
        let error: ErrorType?
        
        do {
            parseData = try Utils.parseTheme(theme)
            error = nil
        } catch let thrownError {
            parseData = nil
            error = thrownError
        }
        
        // Double-check we don't have an invalid theme
        guard let parsedTheme: (name: String, data: ThemeData) = parseData else {
            fatalError("MotifKit Error: INVALID_THEME (\(error!))")
        }
        
        let parsedThemeObject = ParsedTheme(parsedTheme)
        
        if(sharedInstance.themes.contains(parsedThemeObject)) {
            return false
        }
        
        // First, store the theme
        sharedInstance.themes.insert(parsedThemeObject)
        
        // Second, set the default if we need to
        if sharedInstance.currentTheme == nil {
            sharedInstance.currentTheme = parsedTheme.name
        }
        
        return true
    }
    
    public class func getThemes() -> [String] {
        // Return a string list of the currently loaded themes
        return sharedInstance.themes.map({$0.name})
    }
    
    public class func getCurrentTheme() -> String? {
        return sharedInstance.currentTheme
    }
    
    public class func resetThemes() {
        // Reset all our currently loaded themes
        sharedInstance.themes.removeAll()
        sharedInstance.currentTheme = nil
    }
    
    public class func setTheme(key: String) -> Bool {
        // If the theme doesn't exist, return false
        guard sharedInstance.themes.contains({ $0.name == key }) else { return false}
        
        // Otherwise, set the theme and update all views
        sharedInstance.currentTheme = key
        
        for event in sharedInstance.updateEvents {
            event()
        }
        
        return true
    }
    
    public class func setEnum<T: RawRepresentable>(type: T.Type, key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            sharedInstance.setObject(type, key: key, file: file, completion: { object in
                // If it's an enum, work around that and set the rawValue
                passedClass.setValue(object.rawValue as? AnyObject, forKey: variable)
            })
        }
    }
    
    public class func setObject<T>(type: T.Type, key: String, file: String = #file, completion: (T) -> Void) {
        sharedInstance.setObject(type, key: key, file: file, completion: completion)
    }
    
    public class func setObjects<T>(type: T.Type, keys: [String], file: String = #file, completion: ([T]) -> Void) {
        func applyObjects() {
            var data = [T]()
            
            for key in keys {
                sharedInstance.setObjectOnce(type, key: key, file: file, completion: { result in
                    data.append(result)
                })
            }
            
            return completion(data)
        }
        
        applyObjects()
        
        sharedInstance.updateEvents.append({
            applyObjects()
        })
    }
    
    public class func setObject<T>(type: T.Type, key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            
            sharedInstance.setObject(type, key: key, file: file, completion: { object in
                // If it's an object, handle it as an object
                passedClass.setValue(object as? AnyObject, forKey: variable)
            })
        }
    }
    
    public class func onThemeChange(completion: () -> Void) {
        sharedInstance.updateEvents.append(completion)
    }
    
    private func setObject<T>(type: T.Type, key: String, file: String, completion: (T) -> Void) {
        // Remove any spaces from the file string, and get the name of the calling class from its file path
        let patchedFile = file.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let className = (NSURL(string: patchedFile)!.URLByDeletingPathExtension?.lastPathComponent)!
        
        func applyObject() {
            do {
                let object: T = try Utils.getRelevantObject(className, key: key)
                
                completion(object)
            } catch let error {
                fatalError("MotifKit Error: SET_OBJECT (\(error))")
            }
        }
        
        // Initially set the object using our helper function
        applyObject()
        
        // And then add a handler to set the object and add it to our update event stack
        updateEvents.append({
            applyObject()
        })
    }
    
    private func setObjectOnce<T>(type: T.Type, key: String, file: String, completion: (T) -> Void) {
        // Remove any spaces from the file string, and get the name of the calling class from its file path
        let patchedFile = file.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let className = (NSURL(string: patchedFile)!.URLByDeletingPathExtension?.lastPathComponent)!
        
        do {
            let object: T = try Utils.getRelevantObject(className, key: key)
            
            completion(object)
        } catch let error {
            fatalError("MotifKit Error: SET_OBJECT (\(error))")
        }
    }
}