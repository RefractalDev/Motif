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
    
    public class func setColor(_ key: String, file: String = #file, completion: (UIColor) -> Void) {
        setObject(UIColor.self, key: key, file: file, completion: completion)
    }
    
    public class func setAttributes(_ key: String, file: String = #file, completion: ([String: AnyObject]) -> Void) {
        setObject([String: AnyObject].self, key: key, file: file, completion: completion)
    }
    
    public class func setFont(_ key: String, size: CGFloat, file: String = #file, completion completionHandler: @escaping (UIFont) -> Void) {
        setObject(UIFont.self, key: key, file: file, completion: { (font: UIFont) in
            completionHandler(font.withSize(size))
        })
    }
    
    public class func setColors(_ keys: [String], file: String = #file, completion: ([UIColor]) -> Void) {
        setObjects(UIColor.self, keys: keys, file: file, completion: completion)
    }
    
    public class func setAttributes(_ keys: [String], file: String = #file, completion: ([[String: AnyObject]]) -> Void) {
        setObjects([String: AnyObject].self, keys: keys, file: file, completion: completion)
    }
    
    public class func setFonts(_ keys: [String], sizes: [CGFloat], file: String = #file, completion completionHandler: @escaping ([UIFont]) -> Void) {
        setObjects(UIFont.self, keys: keys, file: file, completion: { (fonts: [UIFont]) in
            var newResult = [UIFont]()
            
            for (index, font) in fonts.enumerated() {
                newResult.append(font.withSize(sizes[index]))
            }
            
            return completionHandler(newResult)
        })
    }
    
    // Define our object specific versions
    
    public class func setColor(_ key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            setObject(UIColor.self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func setAttributes(_ key: String, target: NSObject..., variable: String, file: String = #file) {
        for passedClass in target {
            setObject([String: AnyObject].self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func setFont(_ key: String, target: NSObject..., variable: String, size: CGFloat, file: String = #file) {
        for passedClass in target {
            setObject(UIFont.self, key: key, file: file, completion: { (font: UIFont) in
                passedClass.setValue(font.withSize(size), forKey: variable)
            })
        }
    }
}
