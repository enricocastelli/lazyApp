//
//  StayHomeTests.swift
//  StayHomeTests
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import XCTest
@testable import StayHome

class StayHomeTests: XCTestCase {


    func testDateHours() {
        for index in 0...23 {
            var indexString = index.string
            if indexString.count == 1 {
                indexString = "0\(indexString)"
            }
            let dateString = "\(indexString):01"
            guard let date = dateString.toDate() else { XCTFail()
                return}
            XCTAssert(date.getTime() == timeExpectedForIndex(index))
        }
    }
    
    func timeExpectedForIndex(_ ind: Int) -> Date.Time {
        switch ind {
        case 0: return .Night
        case 1: return .Night
        case 2: return .Night
        case 3: return .Night
        case 4: return .Night
        case 5: return .Night
        case 6: return .Morning
        case 7: return .Morning
        case 8: return .Morning
        case 9: return .Morning
        case 10: return .Morning
        case 11: return .Morning
        case 12: return .Morning
        case 13: return .Afternoon
        case 14: return .Afternoon
        case 15: return .Afternoon
        case 16: return .Afternoon
        case 17: return .Afternoon
        case 18: return .Afternoon
        case 19: return .Evening
        case 20: return .Evening
        case 21: return .Evening
        case 22: return .Evening
        case 23: return .Night
        case 24: return .Night
        default: return.Day
        }
    }
}

extension String {
    
    func toDate(_ format: String = "HH:mm") -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.date(from: self)
    }
}
