//
//  StoreProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit


enum StoreKeys {
    static let isFirstTime = "isFirstTime"
    static let ID = "ID"
    static let name = "name"
    static let startDate = "startDate"
    static let animal = "animal"
    static let fcmToken = "fcmToken"

}

protocol StoreProvider {}

extension StoreProvider {
    
    func storeFirstTime() {
        UserDefaults.standard.set(false, forKey: StoreKeys.isFirstTime)
    }
    
    func isFirstTime() ->  Bool {
//        if isSimulator() { return true }
        if let _ = UserDefaults.standard.object(forKey: StoreKeys.isFirstTime) as? Bool {
            return false
        } else {
            return true
        }
    }
    
    func setID(_ id: String) {
        UserDefaults.standard.set(id, forKey: StoreKeys.ID)
    }
    
    func getID() -> String {
        if let existingID = UserDefaults.standard.object(forKey: StoreKeys.ID) as? String {
            return existingID
        } else {
            let uuid = getName() + "-" + String(UUID().uuidString.prefix(5))
            setID(uuid.lowercased())
            return uuid.lowercased()
        }
    }
    
    func setName(_ name: String) {
        UserDefaults.standard.set(name, forKey: StoreKeys.name)
    }
    
    func getName() -> String {
        return UserDefaults.standard.object(forKey: StoreKeys.name) as? String ?? UIDevice.current.name.playerName
    }
    
    func setStartDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: StoreKeys.startDate)
    }
    
    func getStartDate() -> Date {
        if let startDate =  UserDefaults.standard.object(forKey: StoreKeys.startDate) as? Date {
            return startDate
        } else {
            let dateToday = Date()
            setStartDate(dateToday)
            return dateToday
        }
    }
    
    func storeAnimal(_ animal: LazyAnimal) {
        UserDefaults.standard.set(animal.index, forKey: StoreKeys.animal)
    }
    
    func getAnimal() ->  LazyAnimal? {
        guard let animalIndex = UserDefaults.standard.object(forKey: StoreKeys.animal) as? Int else { return nil }
        return LazyAnimal(rawValue: animalIndex)
    }
    
    func storeFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: StoreKeys.fcmToken)
    }
    
    
    func getFCMToken() -> String? {
        return UserDefaults.standard.object(forKey: StoreKeys.fcmToken) as? String
    }
}

