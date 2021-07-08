//
//  String+LibraryHourFormatting.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/25/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.
//

import Foundation

extension String {
    var formattedHours: String {
        let dayOfWeekArray = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
        let formattedDayOfWeekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var newHoursString = self
        var returnString = "Hours:"
        for currentDayOfWeek in dayOfWeekArray {
            let index = dayOfWeekArray.firstIndex(of: currentDayOfWeek)
            newHoursString = newHoursString.replacingOccurrences(of: currentDayOfWeek, with: formattedDayOfWeekArray[index!])
        }
        newHoursString = newHoursString.replacingOccurrences(of: ",", with: ":")
        let hoursStringArray = newHoursString.components(separatedBy: "; ")
        for hourString in hoursStringArray {
            returnString = returnString + "\n" + hourString
        }
        return returnString
    }
}
