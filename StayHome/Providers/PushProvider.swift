//
//  PushProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 03/04/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import Firebase


protocol PushProvider: StoreProvider {}

fileprivate let gURL = URL(string: "https://fcm.googleapis.com/fcm/send")!
fileprivate let serverKey = "key=AAAAZuJCEfQ:APA91bGEVCR4Me57sgsA98YTSDK8nMTaHcsTfVQP-L5GzYcs_wTXYHwWoAphK9fRpHHsxkYOb9MXX-xVTNzKoQQPyXA-YHNVwu2JUVqOJYNsmAfFaT4i5zhSBcc6zGSGsQxGkj4aHjpc"

extension PushProvider {
    
    func sendFriendsPush(_ id: String) {
        sendPush(id, params: Push(to: "", notification: NotificationObject(title: "Hello Lazy!", body: "\(self.getName()) just added you as a friend!", badge: 1), data: ["playerID": getID()]))
    }
    
    func sendChallengePush(_ challengeID: String, friendID: String, endingTime: ChallengeDuration) {
        sendPush(friendID, params: Push(to: "", notification: NotificationObject(title: "Hello Lazy!", body: "\(self.getName()) just invited you to a lazy challenge!", badge: 1), data: ["challengeID": challengeID, "isScheduled" : "true", "scheduledTime" : endingTime.string()]))
    }
    
    private func sendPush(_ id: String, params: Push) {
        getUserToken(id, success: { (token) in
            var params = params
            params.to = token
            var request = URLRequest(url: gURL)
            request.httpMethod = "POST"
            request.httpBody = params.toJSONData()
            request.setValue(serverKey, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in }
            task.resume()
            
        }) { (error) in
            Logger.error(error)
        }
    }
    
    private func sendLocal(_ endingTime: ChallengeDuration) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                Logger.warning("Notification auth not granted")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Hey Lazy!"
        content.body = "A challenge just finished!"
        content.badge = 1
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: endingTime.date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let _ = error {
                Logger.warning("Notification not sent correctly")
            }
        })
    }
    
    private func getUserToken(_ id: String, success: @escaping(String) ->(), failure: @escaping(Error) ->()) {
        tokenCollection().document(id).getDocument { (doc, error) in
            guard error == nil else { failure(error!)
                return }
            guard let token = doc?.data()?["token"] as? String else {
                failure(LazyError.parsingError)
                return }
            success(token)
        }
    }
    
    private func tokenCollection() -> CollectionReference {
        return Firestore.firestore().collection("tokens")
    }
}

struct Push: Codable {
    
    var to: String
    let notification: NotificationObject
    let data: [String: String]
}

struct NotificationObject: Codable {
    
    let title: String
    let body: String
    let badge: Int
}

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

