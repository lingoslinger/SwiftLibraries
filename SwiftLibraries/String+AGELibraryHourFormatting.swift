//
//  String+AGELibraryHourFormatting.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/25/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import Foundation

public extension String {
    public var formattedLibraryHours : String {
        var hoursArray = ["", "", "", "", "", "", ""]
        let dayOfWeekArray = ["M", "TU", "W", "TH", "F", "SA", "SU"]
        let formattedDayOfWeekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        let hourStringArray = self.componentsSeparatedByString("; ")
        for rawHoursString in hourStringArray {
            let seperatedDaysAndHours = rawHoursString.componentsSeparatedByString(": ")
            let seperatedDays = seperatedDaysAndHours[0]
            let seperatedHours = seperatedDaysAndHours[1]
            var abbreviatedDays : NSMutableArray = []
            if seperatedDaysAndHours[0].containsString("-") {
                let startStopHoursDayArray = seperatedDays.componentsSeparatedByString("-")
                let startIndex : Int = dayOfWeekArray.indexOf(startStopHoursDayArray[0])!
                let stopIndex : Int = dayOfWeekArray.indexOf(startStopHoursDayArray[1])!
                for j in startIndex...stopIndex {
                    abbreviatedDays.addObject(dayOfWeekArray[j])
                }
            } else {
                abbreviatedDays = NSMutableArray.init(array: seperatedDays.componentsSeparatedByString(", "))
            }

            let formattedHoursString = formattedHoursForAbbreviatedHours(seperatedHours)
            for rawDay in abbreviatedDays {
                let abbreviatedDay = rawDay.stringByReplacingOccurrencesOfString(" ", withString: "")
                let dayIndex = dayOfWeekArray.indexOf(abbreviatedDay)
                hoursArray[dayIndex!] = formattedHoursString
            }
        }
        
        var returnString = "Hours:\n"
        for i in 0..<7 {
            let hoursString = formattedDayOfWeekArray[i] + ": " + hoursArray[i]
            returnString += hoursString
            if i < 6 {
                returnString += "\n"
            }
        }
        
        return returnString
    }
    
    func formattedHoursForAbbreviatedHours(abbreviatedHours : String) -> String {
        if abbreviatedHours == "Closed" {
            return abbreviatedHours
        }
        let openCloseArray = abbreviatedHours.componentsSeparatedByString("-")
        let openTimeString = formattedTimeForAbbreviatedTime(openCloseArray[0])
        let closeTimeString = formattedTimeForAbbreviatedTime(openCloseArray[1])
        return openTimeString + " - " + closeTimeString
    }
    
    func formattedTimeForAbbreviatedTime(abbreviatedTime : String) -> String {
        let abbreviatedTimeLength = (abbreviatedTime as NSString).length
        let endIndex = abbreviatedTimeLength == 4 ? 2 : 1
        let numericHourString = (abbreviatedTime as NSString).substringToIndex(endIndex)
        let ampmString = (abbreviatedTime as NSString).substringFromIndex(abbreviatedTimeLength - 2)
        return numericHourString + ":00" + ampmString
    }
}