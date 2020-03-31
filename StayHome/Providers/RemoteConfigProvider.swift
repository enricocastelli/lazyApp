//
//  RemoteConfigProvider.swift
//  StayHome
//
//  Created by Enrico Castelli on 30/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import Foundation
import Firebase

protocol RemoteConfigProvider {}

extension RemoteConfigProvider{
    
    
    private func remoteConfig() -> RemoteConfig {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        return remoteConfig
    }
    
    func getDesc(_ animal: String) -> String? {
        let descriptions = remoteConfig().configValue(forKey: "desc").jsonValue as? [String: String]
        return descriptions?[animal]
    }
    
    func getAppStoreLink() -> String {
        return remoteConfig().configValue(forKey: "appStoreLink").stringValue ?? ""
    }
    
    func getTitle() -> String? {
        let title = remoteConfig().configValue(forKey: "title").stringValue
        if let title = title, !title.isEmpty {
            return title
        }
        return nil
    }
}

