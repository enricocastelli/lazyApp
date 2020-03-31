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
    guard var diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day else { throw LazyError.wrongDate }
    diffInDays = diffInDays == 0 ? 1 : diffInDays
    let average = ((steps/2) + distance)/Double(diffInDays)
    let score = (1 - (average/20000))*100
    UserData.shared.score = score
    return score
}


enum LazyAnimal: Int, RemoteConfigProvider {
    
    case meerkat, bird, horse, racoon, dog, koi, frog, panda, otter, koala, squirrel, corgi, cat, sloth
    
    var index: Int {
        return self.rawValue
    }
    
    var color: UIColor {
        switch self {
        case .meerkat: return UIColor(hex: "FEF8EB")
        case .bird: return UIColor(hex: "D4F9F0")
        case .horse: return UIColor(hex: "F0EAD3")
        case .racoon: return UIColor(hex: "F8DB55")
        case .dog: return UIColor(hex: "F4B3BE")
        case .koi: return UIColor(hex: "94EEFD")
        case .frog: return UIColor(hex: "7EB9A8")
        case .panda: return UIColor(hex: "CCFBA3")
        case .otter: return UIColor(hex: "AEECE4")
        case .koala: return UIColor(hex: "EEEADB")
        case .squirrel: return UIColor(hex: "D3E8DF")
        case .corgi: return UIColor(hex: "ACEDF4")
        case .cat: return UIColor(hex: "F7D0C4")
        case .sloth: return UIColor(hex: "FCEBB6")
        }
    }
    
    var image: UIImage {
        switch self {
        case .meerkat: return UIImage.meerkat
        case .bird: return UIImage.bird
        case .horse: return UIImage.horse
        case .racoon: return UIImage.racoon
        case .dog: return UIImage.dog
        case .koi: return UIImage.koi
        case .frog: return UIImage.frog
        case .panda: return UIImage.panda
        case .otter: return UIImage.otter
        case .koala: return UIImage.koala
        case .squirrel: return UIImage.squirrel
        case .corgi: return UIImage.corgi
        case .cat: return UIImage.cat
        case .sloth: return UIImage.sloth
        }
    }
    
    var name: String {
        switch self {
        case .meerkat: return "Proactive Meerkat"
        case .bird: return "Delivering Stork"
        case .horse: return "Racing Horse"
        case .racoon: return "Happy Racoon"
        case .dog: return "Busy Doggo"
        case .koi: return "Cool Koi"
        case .frog: return "Yoga Frog"
        case .panda: return "Afterwork Panda"
        case .otter: return "Floating Otter"
        case .koala: return "Napping Koala"
        case .squirrel: return "Netflix Squirrel"
        case .corgi: return "Sunday Corgi"
        case .cat: return "Passed Out Cat"
        case .sloth: return "Granpa Sloth"
        }
    }
    
    var description: String? {
        return getDesc(name)
    }
    
    static let array: [LazyAnimal] = [.meerkat,
                                  .bird,
                                  .horse,
                                  .racoon,
                                  .dog,
                                  .koi,
                                  .frog,
                                  .panda,
                                  .otter,
                                  .koala,
                                  .squirrel,
                                  .corgi,
                                  .cat,
                                  .sloth]
    
    static func typeForLevel(_ level: Double) -> LazyAnimal {
        switch level {
        case _ where level <= 5: return .meerkat
        case _ where level > 5 && level <= 12: return .bird
        case _ where level > 12 && level <= 19: return .horse
        case _ where level > 19 && level <= 27: return .racoon
        case _ where level > 27 && level <= 34: return .dog
        case _ where level > 34 && level <= 42: return .koi
        case _ where level > 42 && level <= 48: return .frog
        case _ where level > 48 && level <= 56: return .panda
        case _ where level > 56 && level <= 63: return .otter
        case _ where level > 63 && level <= 71: return .koala
        case _ where level > 71 && level <= 79: return .squirrel
        case _ where level > 79 && level <= 87: return .corgi
        case _ where level > 87 && level <= 95: return .cat
        case _ where level > 95: return .sloth
        default: return .koi
        }
    }
}
