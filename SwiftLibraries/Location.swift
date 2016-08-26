//
//	Location.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import Foundation

class Location : NSObject {

	var latitude : String!
	var longitude : String!
	var needsRecoding : Bool!

	init(fromDictionary dictionary: NSDictionary) {
		latitude = dictionary["latitude"] as? String
		longitude = dictionary["longitude"] as? String
		needsRecoding = dictionary["needs_recoding"] as? Bool
	}

	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if latitude != nil {
			dictionary["latitude"] = latitude
		}
		if longitude != nil {
			dictionary["longitude"] = longitude
		}
		if needsRecoding != nil {
			dictionary["needs_recoding"] = needsRecoding
		}
		return dictionary
	}
}