//
//  UserData.swift
//  StayHome
//
//  Created by Enrico Castelli on 24/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation

class UserData {
    
    static let shared = UserData()
    
    var mePlayer: Player?
    var friends: [Player]?
    var score: Double?
}
