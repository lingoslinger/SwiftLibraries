//
//	Library.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import Foundation

class Library : NSObject {

	var address : String!
	var city : String!
	var cybernavigator : String!
	var hoursOfOperation : String!
	var location : Location!
	var name : String!
	var phone : String!
	var state : String!
	var teacherInTheLibrary : String!
	var website : Website!
	var zip : String!

	init(fromDictionary dictionary: NSDictionary){
		address = dictionary["address"] as? String
		city = dictionary["city"] as? String
		cybernavigator = dictionary["cybernavigator"] as? String
		hoursOfOperation = dictionary["hours_of_operation"] as? String
		if let locationData = dictionary["location"] as? NSDictionary{
			location = Location(fromDictionary: locationData)
		}
		name = dictionary["name_"] as? String
		phone = dictionary["phone"] as? String
		state = dictionary["state"] as? String
		teacherInTheLibrary = dictionary["teacher_in_the_library"] as? String
		if let websiteData = dictionary["website"] as? NSDictionary{
			website = Website(fromDictionary: websiteData)
		}
		zip = dictionary["zip"] as? String
	}

	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if address != nil{
			dictionary["address"] = address
		}
		if city != nil{
			dictionary["city"] = city
		}
		if cybernavigator != nil{
			dictionary["cybernavigator"] = cybernavigator
		}
		if hoursOfOperation != nil{
			dictionary["hours_of_operation"] = hoursOfOperation
		}
		if location != nil{
			dictionary["location"] = location.toDictionary()
		}
		if name != nil{
			dictionary["name_"] = name
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if state != nil{
			dictionary["state"] = state
		}
		if teacherInTheLibrary != nil{
			dictionary["teacher_in_the_library"] = teacherInTheLibrary
		}
		if website != nil{
			dictionary["website"] = website.toDictionary()
		}
		if zip != nil{
			dictionary["zip"] = zip
		}
		return dictionary
	}
}
