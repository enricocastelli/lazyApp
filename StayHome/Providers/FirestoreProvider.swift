//
//  FirestoreProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Firebase
import FirebaseFirestore

protocol FirestoreProvider: HealthProvider, PushProvider {}

extension FirestoreProvider  {
    
    func update(steps: Double, distance: Double, _ success: @escaping() ->(), failure: @escaping(Error) ->()) {
        do {
            let score = try lazyness(steps: steps, distance: distance, startDate: self.getStartDate())
            let mePlayer = Player(id: self.getID(), name: self.getName(), score: score, lastUpdate: Timestamp(date: Date()), friends:nil, friendsPending: nil)
            UserData.shared.mePlayer = mePlayer
            self.updateStats(documentID: self.getID(), player: mePlayer, success: success, failure: failure)
        } catch  {
            failure(error)
        }
    }
    
    func addFriendComplete(_ id: String, success: @escaping() ->(), failure: @escaping(Error) ->()) {
        collection().document(id).getDocument { (document, error) in
            guard error == nil else { failure(error!)
                return }
            guard let document = document, document.exists, var player = document.data()?.toPlayer() else {
                failure(LazyError.userNotFound)
                return }
            var updatedFriends = (player.friendsPending ?? [])
            guard !updatedFriends.contains(self.getID()) else {
                self.addFriendToSelf(id, success: success, failure: failure)
                return
            }
            updatedFriends.append(self.getID())
            player.friendsPending = updatedFriends
            self.updateStats(documentID: id, player: player, success: {
                self.addFriendToSelf(id, success: success, failure: failure)
                self.sendFriendsPush(id)
            }, failure: failure)
        }
    }

    func addFriendToSelf(_ id: String, success: @escaping() ->(), failure: @escaping(Error) ->()) {
        getMePlayer(success: { (player) in
            var mePlayer = player
            var updatedFriends = (mePlayer.friends ?? [])
            guard !updatedFriends.contains(id) else {
                failure(LazyError.alreadyFriend)
                return
            }
            if var pending = mePlayer.friendsPending, pending.contains(id) {
                pending.remove(at: pending.firstIndex(of: id)!)
                mePlayer.friendsPending = pending
            }
            updatedFriends.append(id)
            mePlayer.friends = updatedFriends
            UserData.shared.mePlayer = mePlayer
            self.updateStats(documentID: self.getID(), player: mePlayer, success: success, failure: failure)
        }, failure: failure)
    }
    
    func removePendingFriends(success: @escaping() ->(), failure: @escaping(Error) ->()) {
        getMePlayer(success: { (player) in
            var mePlayer = player
            mePlayer.friendsPending = []
            UserData.shared.mePlayer = mePlayer
            self.updateStats(documentID: self.getID(), player: mePlayer, success: success, failure: failure)
        }, failure: failure)
    }
    
    func removeFriend(_ id: String, success: @escaping() ->(), failure: @escaping(Error) ->()) {
        getMePlayer(success: { (player) in
            var mePlayer = player
            var friends = (mePlayer.friends ?? [])
            guard friends.contains(id) else {
                failure(LazyError.parsingError)
                return
            }
            friends.remove(at: friends.firstIndex(of: id)!)
            mePlayer.friends = friends
            UserData.shared.mePlayer = mePlayer
            self.updateStats(documentID: self.getID(), player: mePlayer, success: success, failure: failure)
        }, failure: failure)
    }
    
    
    private func updateStats(documentID: String, player: Player, success: @escaping() ->(), failure: @escaping(Error) ->()) {
        guard let json = player.toDictionary() else {
            failure(LazyError.errorUpdating)
            return }
        collection().document(documentID).setData(json, merge: true)
        DispatchQueue.main.async {
            success()
        }
    }
    
    private func getMePlayer(success: @escaping(Player) ->(), failure: @escaping(Error) ->()) {
        collection().document(getID()).getDocument { (doc, error) in
            guard error == nil else { failure(error!)
            return }
            guard let mePlayer = doc?.data()?.toPlayer() else {
                failure(LazyError.errorUpdating)
                return }
            UserData.shared.mePlayer = mePlayer
            success(mePlayer)
        }
    }
    
    func getFriends(success: @escaping([Player]) ->(), failure: @escaping(Error) ->()) {
        getMePlayer(success: { (mePlayer) in
            guard let friendsList = mePlayer.friends, !friendsList.isEmpty else {
                success([])
                return }
            self.collection().getDocuments { (snapshot, error) in
                guard error == nil else { failure(error!)
                return }
                guard let players = snapshot?.documents.map({ (doc) -> Player? in
                    doc.data().toPlayer()
                }).compactMap({$0}) else {
                    failure(LazyError.parsingError)
                    return
                }
                let friends = players.filter { friendsList.contains($0.id)}
                UserData.shared.friends = friends
                success(friends)
            }
        }, failure: failure)
    }
    
    private func collection() -> CollectionReference {
        return Firestore.firestore().collection("players")
    }
    
    private func challenge() -> CollectionReference {
        return Firestore.firestore().collection("challenges")
    }
    
    func addFriendsObserver(_ callback: @escaping([String]) -> ()) {
        collection().document(getID()).addSnapshotListener { (document, error) in
            guard let pending = document?.data()?.toPlayer()?.friendsPending, !pending.isEmpty else { return }
            callback(pending)
        }
    }
    
    func saveFCMToken() {
        let token = getFCMToken() ?? "No token found"
        Firestore.firestore().collection("tokens").document(getID()).setData(["token" : token])
    }
        
    // MARK: - CHALLENGES
    
    func createChallenge(_ challenger: String, endingDate: ChallengeDuration) {
        let challengeID =  getID() + challenger
        let challengeModel = Challenge(id: challengeID, playerID: getID(), challengerID: challenger, score1: 0, score2: 0, startingDate: Timestamp(date: Date()), endingDate: endingDate.ending())
        challenge().document(challengeID).setData(challengeModel.toDictionary())
        sendChallengePush(challengeID, friendID: challenger, endingTime: endingDate)
        sendChallengeLocal()
    }
    
    func getChallenge(_ challenger: String, endingDate: ChallengeDuration) {

        
    }
    
    
}

