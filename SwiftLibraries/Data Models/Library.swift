//
//	LibraryList.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.

import Foundation

struct Library : Codable {

	let address : String?
	let city : String?
	let cybernavigator : String?
	let serviceHours : String?
	let location : Location?
	let branch : String?
	let phone : String?
	let state : String?
	let teacherInTheLibrary : String?
	let website : Website?
	let zip : String?

	enum CodingKeys: String, CodingKey {
		case address = "address"
		case city = "city"
		case cybernavigator = "cybernavigator"
		case serviceHours = "service_hours"
		case location = "location"
		case branch = "branch_"
		case phone = "phone"
		case state = "state"
		case teacherInTheLibrary = "teacher_in_the_library"
		case website = "website"
		case zip = "zip"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		cybernavigator = try values.decodeIfPresent(String.self, forKey: .cybernavigator)
        serviceHours = try values.decodeIfPresent(String.self, forKey: .serviceHours)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
        branch = try values.decodeIfPresent(String.self, forKey: .branch)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		teacherInTheLibrary = try values.decodeIfPresent(String.self, forKey: .teacherInTheLibrary)
        website = try values.decodeIfPresent(Website.self, forKey: .website)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
    }
}
