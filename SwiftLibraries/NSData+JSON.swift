//
//  NSData+JSON.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/25/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import Foundation

public typealias JSONObject = [String:AnyObject]


/**
 Gives the ability to convert NSData objects to JSONObject type
 */
public extension Data
{
    
    /**
     Converts the data object to an array of JSONObjects
     
     - help: JSONObject = [String:AnyObject]
     
     - returns: The array of JSONObject's
     */
    public var jsonArrayValue : [JSONObject] {
        guard
            let json     = try? JSONSerialization.jsonObject(with: self, options: []),
            let objects  = json as? [JSONObject]
            else
        {
            return []
        }
        return objects
    }
    
    /**
     Converts the data object to a JSONObject or nil on failure
     
     - help: JSONObject = [String:AnyObject]
     
     - returns: The JSONObject or nil
     */
    public var jsonDictionaryValue : JSONObject? {
        guard
            let json     = try? JSONSerialization.jsonObject(with: self, options: []),
            let object  = json as? JSONObject
            else
        {
            return nil
        }
        return object
    }
}
