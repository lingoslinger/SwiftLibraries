//
//	Website.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import Foundation

class Website : NSObject {

	var url : String!

	init(fromDictionary dictionary: NSDictionary) {
		url = dictionary["url"] as? String
	}

	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if url != nil {
			dictionary["url"] = url
		}
		return dictionary
	}
}