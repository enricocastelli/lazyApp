//
//  Model.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Player {
    let id: String
    let name: String
    let score: Double
    let lastUpdate: Timestamp
    var friends: [String]?
    var friendsPending: [String]?
}

struct Challenge {
    let id: String
    let playerID: String
    let challengerID: String
    let score1: Double
    let score2: Double
    var startingDate: Timestamp
    var endingDate: Timestamp
}


enum ChallengeDuration: String {
    case EndOfDay, Tomorrow, NextWeek
    
    func ending() -> Timestamp {
        return Timestamp(date: date())
    }
    
    func date() -> Date {
        switch self {
        case .EndOfDay: return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        case .Tomorrow: return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        case .NextWeek: return  Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        }
    }
    
    func string() -> String {
        return Calendar.current.date(byAdding: .second, value: 10, to: Date())!.toString()
//        return date().toString()
    }
}



extension Dictionary where Key == String, Value == Any {
    
    func toPlayer() -> Player? {
        guard let id = self["id"] as? String, let name = self["name"] as? String, let score = self["score"] as? Double, let lastUpdate = self["lastUpdate"] as? Timestamp  else { return nil}
        return Player(id: id, name: name, score: score, lastUpdate: lastUpdate, friends: self["friends"] as? [String], friendsPending: self["friendsPending"] as? [String])
    }
    
    func toChallenge() -> Challenge? {
        guard let id = self["id"] as? String, let playerID = self["playerID"] as? String, let challengerID = self["challengerID"] as? String, let score1 = self["score1"] as? Double, let score2 = self["score2"] as? Double, let startingDate = self["startingDate"] as? Timestamp, let endingDate = self["endingDate"] as? Timestamp  else { return nil}
        return Challenge(id: id, playerID: playerID, challengerID: challengerID, score1: score1, score2: score2, startingDate: startingDate, endingDate: endingDate)
    }
}

extension Dictionary where Key == String, Value == [String: Any] {

    func toPlayers() -> [Player] {
        var arr = [Player]()
        for element in self.values {
            if let player = element.toPlayer() {
                arr.append(player)
            }
        }
        return arr
    }
    
    func toChallenges() -> [Challenge] {
        var arr = [Challenge]()
        for element in self.values {
            if let chall = element.toChallenge() {
                arr.append(chall)
            }
        }
        return arr
    }
}

extension Player {
   
    func toDictionary() -> [String: Any]? {
        var dictionary: [String: Any] = ["id": id, "name": name, "score": score, "lastUpdate": lastUpdate]
        if let friends = friends {
            dictionary["friends"] = friends
        }
        if let friendsPending = friendsPending {
            dictionary["friendsPending"] = friendsPending
        }
        return dictionary
    }
}

extension Challenge {
   
    func toDictionary() -> [String: Any] {
        return ["id": id, "playerID": playerID, "challengerID": challengerID, "score1": score1, "score2": score2, "startingDate": startingDate, "endingDate": endingDate]
    }
}

