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
    
    public class func set(color key: String, file: String = #file, completion: @escaping (UIColor) -> Void) {
        set(object: UIColor.self, key: key, file: file, completion: completion)
    }
    
    public class func set(attribute key: String, file: String = #file, completion: @escaping ([String: AnyObject]) -> Void) {
        set(object: [String: AnyObject].self, key: key, file: file, completion: completion)
    }
    
    public class func set(font key: String, size: CGFloat, file: String = #file, completion completionHandler: @escaping (UIFont) -> Void) {
        set(object: UIFont.self, key: key, file: file, completion: { (font: UIFont) in
            completionHandler(font.withSize(size))
        })
    }
    
    public class func set(colors keys: [String], file: String = #file, completion: @escaping ([UIColor]) -> Void) {
        set(objects: UIColor.self, keys: keys, file: file, completion: completion)
    }
    
    public class func set(attributes keys: [String], file: String = #file, completion: @escaping ([[String: AnyObject]]) -> Void) {
        set(objects: [String: AnyObject].self, keys: keys, file: file, completion: completion)
    }
    
    public class func set(fonts keys: [String], sizes: [CGFloat], file: String = #file, completion completionHandler: @escaping ([UIFont]) -> Void) {
        set(objects: UIFont.self, keys: keys, file: file, completion: { (fonts: [UIFont]) in
            var newResult = [UIFont]()
            
            for (index, font) in fonts.enumerated() {
                newResult.append(font.withSize(sizes[index]))
            }
            
            return completionHandler(newResult)
        })
    }
    
    // Define our object specific versions
    
    public class func set(color key: String, target: [NSObject], variable: String, file: String = #file) {
        for passedClass in target {
            set(object: UIColor.self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func set(attribute key: String, target: [NSObject], variable: String, file: String = #file) {
        for passedClass in target {
            set(object: [String: AnyObject].self, key: key, target: passedClass, variable: variable, file: file)
        }
    }
    
    public class func set(font key: String, target: [NSObject], variable: String, size: CGFloat, file: String = #file) {
        for passedClass in target {
            set(object: UIFont.self, key: key, file: file, completion: { (font: UIFont) in
                passedClass.setValue(font.withSize(size), forKey: variable)
            })
        }
    }
    
    public class func set(color key: String, target: NSObject, variable: String, file: String = #file) {
        set(color: key, target: [target], variable: variable, file: file)
    }
    
    public class func set(attribute key: String, target: NSObject, variable: String, file: String = #file) {
        set(attribute: key, target: [target], variable: variable, file: file)
    }
    
    public class func set(font key: String, target: NSObject, variable: String, size: CGFloat, file: String = #file) {
        set(font: key, target: [target], variable: variable, size: size, file: file)
    }
}
