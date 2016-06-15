//
//  MotifTypeFunctions.swift
//  MotifKit
//
//  Created by Jonathan Kingsley on 07/05/2016.
//  Copyright © 2016 Refractal. All rights reserved.
//

import Foundation

extension Motif {
    
    // Define our completion handler versions
    
    public class func setColor(key: String, file: String = #file, completion: (UIColor) -> Void) {
        setObject(UIColor.self, key: key, file: file, completion: completion)
    }
    
    public class func setAttributes(key: String, file: String = #file, completion: ([String: AnyObject]) -> Void) {
        setObject([String: AnyObject].self, key: key, file: file, completion: completion)
    }
    
    public class func setFont(key: String, size: CGFloat, file: String = #file, completion completionHandler: (UIFont) -> Void) {
        setObject(UIFont.self, key: key, file: file, completion: { (font: UIFont) in
            completionHandler(font.fontWithSize(size))
        })
    }
    
    public class func setColors(keys: [String], file: String = #file, completion: ([UIColor]) -> Void) {
        setObjects(UIColor.self, keys: keys, file: file, completion: completion)
    }
    
    public class func setAttributes(keys: [String], file: String = #file, completion: ([[String: AnyObject]]) -> Void) {
        setObjects([String: AnyObject].self, keys: keys, file: file, completion: completion)
    }
    
    public class func setFonts(keys: [String], sizes: [CGFloat], file: String = #file, completion completionHandler: ([UIFont]) -> Void) {
        setObjects(UIFont.self, keys: keys, file: file, completion: { (fonts: [UIFont]) in
            var newResult = [UIFont]()
            
            for (index, font) in fonts.enumerate() {
                newResult.append(font.fontWithSize(sizes[index]))
            }
            
            return completionHandler(newResult)
        })
    }
    
    // Define our object specific versions
    
    public class func setColor(key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            setObject(UIColor.self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func setAttributes(key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            setObject([String: AnyObject].self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func setFont(key: String, target: NSObject..., variable: String, size: CGFloat, file: String = #file) {
        for passedClass in target {
            setObject(UIFont.self, key: key, file: file, completion: { (font: UIFont) in
                passedClass.setValue(font.fontWithSize(size), forKey: variable)
            })
        }
    }
}