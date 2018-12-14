//
//  String+LibraryHourFormatting.swift
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
        
        let hourStringArray = self.components(separatedBy: "; ")
        for rawHoursString in hourStringArray {
            let seperatedDaysAndHours = rawHoursString.components(separatedBy: ": ")
            let seperatedDays = seperatedDaysAndHours[0]
            let seperatedHours = seperatedDaysAndHours[1]
            var abbreviatedDays : NSMutableArray = []
            if seperatedDaysAndHours[0].contains("-") {
                let startStopHoursDayArray = seperatedDays.components(separatedBy: "-")
                let startIndex : Int = dayOfWeekArray.index(of: startStopHoursDayArray[0])!
                let stopIndex : Int = dayOfWeekArray.index(of: startStopHoursDayArray[1])!
                for j in startIndex...stopIndex {
                    abbreviatedDays.add(dayOfWeekArray[j])
                }
            } else {
                abbreviatedDays = NSMutableArray.init(array: seperatedDays.components(separatedBy: ", "))
            }

            let formattedHoursString = formattedHoursForAbbreviatedHours(seperatedHours)
            for rawDay in abbreviatedDays {
                let abbreviatedDay = (rawDay as AnyObject).replacingOccurrences(of: " ", with: "")
                let dayIndex = dayOfWeekArray.index(of: abbreviatedDay)
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
    
    func formattedHoursForAbbreviatedHours(_ abbreviatedHours : String) -> String {
        if abbreviatedHours == "Closed" {
            return abbreviatedHours
        }
        let openCloseArray = abbreviatedHours.components(separatedBy: "-")
        let openTimeString = formattedTimeForAbbreviatedTime(openCloseArray[0])
        let closeTimeString = formattedTimeForAbbreviatedTime(openCloseArray[1])
        return openTimeString + " - " + closeTimeString
    }
    
    func formattedTimeForAbbreviatedTime(_ abbreviatedTime : String) -> String {
        let abbreviatedTimeLength = (abbreviatedTime as NSString).length
        let endIndex = abbreviatedTimeLength == 4 ? 2 : 1
        let numericHourString = (abbreviatedTime as NSString).substring(to: endIndex)
        let ampmString = (abbreviatedTime as NSString).substring(from: abbreviatedTimeLength - 2)
        return numericHourString + ":00" + ampmString
    }
}
