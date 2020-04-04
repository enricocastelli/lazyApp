//
//  LazyModel.swift
//  StayHome
//
//  Created by Enrico Castelli on 24/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

/// level of lazyness 0 = active, 100 = most lazy
func lazyness(steps: Double, distance: Double, startDate: Date) throws -> Double {
    guard !isSimulator() else {
        let fakeScore = random(min: 0, max: 100) + 0.2
        UserData.shared.score = fakeScore
        return fakeScore}
    guard var diffInHours = Calendar.current.dateComponents([.hour], from: startDate, to: Date()).hour else { throw LazyError.wrongDate }
    diffInHours = diffInHours == 0 ? 1 : diffInHours
    let average = ((steps/2) + distance)/(Double(diffInHours)/24)
    var score = (1 - (average/20000))*99.9
    if score < 0 { score = 0.1 }
    if score > 100 { score = 99.9 }
    UserData.shared.score = score
    return score
}


enum LazyAnimal: Int, RemoteConfigProvider {
    
    case octopus, goat, eagle, turtle, pangolin, squirrel, owl, whale, panda, sloth

    var index: Int {
        return self.rawValue
    }
    
    var color: UIColor {
        switch self {
        case .octopus: return UIColor(hex: "FEF8EB")
        case .goat: return UIColor(hex: "D4F9F0")
        case .eagle: return UIColor(hex: "F0EAD3")
        case .squirrel: return UIColor(hex: "F8DB55")
        case .turtle: return UIColor(hex: "F4B3BE")
        case .owl: return UIColor(hex: "94EEFD")
        case .pangolin: return UIColor(hex: "7EB9A8")
        case .whale: return UIColor(hex: "AEECE4")
        case .panda: return UIColor(hex: "CCFBA3")
        case .sloth: return UIColor(hex: "EEEADB")
        }
    }
    
    var image: UIImage {
        switch self {
        case .octopus: return UIImage.octopus
        case .goat: return UIImage.goat
        case .eagle: return UIImage.eagle
        case .squirrel: return UIImage.squirrel
        case .turtle: return UIImage.turtle
        case .owl: return UIImage.owl
        case .pangolin: return UIImage.pangolin
        case .whale: return UIImage.whale
        case .panda: return UIImage.panda
        case .sloth: return UIImage.sloth
        }
    }
    
    var name: String {
        switch self {
        case .octopus: return "Busy Octopus"
        case .goat: return "Proactive Goat"
        case .eagle: return "Mother Eagle"
        case .turtle: return "Social Turtle"
        case .pangolin: return "Happy Pangolin"
        case .squirrel: return "Munching Squirrel"
        case .owl: return "Sleepy Owl"
        case .whale: return "Zen Whale"
        case .panda: return "Napping Panda"
        case .sloth: return "Granpa Sloth"
        }
    }
    
    var description: String? {
        return getDesc(name)
    }
    
    static let array: [LazyAnimal] = {
        var arr = [LazyAnimal]()
        for index in 0...9 {
            let animal = LazyAnimal(rawValue: index)!
            arr.append(animal)
        }
        return arr
    }()
    
    static func typeForLevel(_ level: Double) -> LazyAnimal {
        switch level {
        case _ where level <= 10: return .octopus
        case _ where level > 10 && level <= 20: return .goat
        case _ where level > 20 && level <= 30: return .eagle
        case _ where level > 30 && level <= 40: return .turtle
        case _ where level > 40 && level <= 50: return .pangolin
        case _ where level > 50 && level <= 60: return .squirrel
        case _ where level > 60 && level <= 70: return .owl
        case _ where level > 70 && level <= 80: return .whale
        case _ where level > 80 && level <= 90: return .panda
        case _ where level > 90: return .sloth
        default: return .owl
        }
    }
}
