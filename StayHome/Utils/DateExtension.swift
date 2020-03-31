//
//  DateExtension.swift
//  StayHome
//
//  Created by Enrico Castelli on 26/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Timestamp {

    func readableString() -> String {
        let date = dateValue()
        let timeString = "\(date.hoursString):\(date.minutesString)"
        if date.isToday() {
            if date.isVeryRecent() {
                return "A moment ago"
            } else if date.isLessThan1HAgo() {
                return "\(abs(Date().minutes - date.minutes)) minutes ago"
            } else if date.isLessThan5HAgo() {
                return "\(abs(Date().hours - date.hours)) hours ago"
            }
            return "Today at \(timeString)"
        } else if date.isYesterday() {
            return "Yesterday at \(timeString)"
        }
        return "\(date.dayWeekString) \(date.day) - \(date.monthString) at \(timeString)"
    }
}

extension Date {
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var monthString: String {
        return Calendar.getLocalizedMonths()[Calendar.current.component(.month, from: self) - 1]
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var dayWeekString: String {
        return Calendar.getLocalizedDaysWeek()[Calendar.current.component(.weekday, from: self) - 1]
    }
    
    
    var hours: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    // not Int otherwise 09 == 9, 08 == 8 etc
    var hoursString: String {
        var stringHour = String(describing: Calendar.current.component(.hour, from: self))
        if stringHour.count == 1 {
            stringHour = "0\(stringHour)"
        }
        return stringHour
    }
    
    // not Int otherwise 09 == 9, 08 == 8 etc
    var minutesString: String {
        var stringMinute = String(describing: Calendar.current.component(.minute, from: self))
        if stringMinute.count == 1 {
            stringMinute = "0\(stringMinute)"
        }
        return stringMinute
    }
    
    // not Int otherwise 09 == 9, 08 == 8 etc
    var secondsString: String {
        var stringSeconds = String(describing: Calendar.current.component(.second, from: self))
        if stringSeconds.count == 1 {
            stringSeconds = "0\(stringSeconds)"
        }
        return stringSeconds
    }
    
    func isPast() -> Bool {
        return self > Date()
    }
    
    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    func isVeryRecent() -> Bool {
        return self > Date().addingTimeInterval(-60)
    }
    
    func isLessThan1HAgo() -> Bool {
        return self > Date().addingTimeInterval(-3600)
    }
    
    func isLessThan5HAgo() -> Bool {
        return self > Date().addingTimeInterval(-18000)
    }
    
    enum Time {
          case Morning, Afternoon, Evening, Night, Day
          
          var string: String {
              switch self {
              case .Morning: return "Morning"
              case .Afternoon: return "Afternoon"
              case .Evening: return "Evening"
              case .Night: return "Night"
              case .Day: return "Day"
              }
          }
          
          var sameCount: String {
              switch self {
              case .Morning: return "Sleeper"
              case .Afternoon: return "Indolent!"
              case .Evening: return "Lazyness"
              case .Night: return "Sloth"
              case .Day: return "😴😴😴"
              }
          }
      }
      
      func getTime() -> Time {
          switch hours {
          case _ where hours > 5 && hours <= 12: return .Morning
          case _ where hours > 12 && hours <= 18: return .Afternoon
          case _ where hours > 18 && hours <= 22: return .Evening
          case _ where hours > 22: return .Night
          case _ where hours <= 5: return .Night
          default: return .Day
          }
      }
}

extension Calendar {
    
    static func getLocalizedDaysWeek() -> [String] {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale.current
        return calendar.shortWeekdaySymbols
    }
    
    static func getLocalizedMonths() -> [String] {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale.current
        return calendar.shortMonthSymbols
    }
}
