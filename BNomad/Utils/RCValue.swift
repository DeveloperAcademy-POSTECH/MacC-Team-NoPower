//
//  RCValue.swift
//  BNomad
//
//  Created by hyo on 2022/11/03.
//

import Foundation
import FirebaseRemoteConfig

enum ValueKey: String {
    case isLoginFirst
}

class RCValue {
    static let shared = RCValue()
    
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    private init () {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            ValueKey.isLoginFirst.rawValue: true
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchCloudValues() {
        activateDebugMode()
        
        RemoteConfig.remoteConfig().fetch { [weak self] _, error in
            if let error = error {
                print("error fetching remote values \(error)")
                return
            }
            
            RemoteConfig.remoteConfig().activate { [weak self] _, _ in
                print("Retrieved values from the cloud!")
                self?.fetchComplete = true
                print("RCValue.isLoginFirst", RCValue.shared.bool(forKey: ValueKey.isLoginFirst))
                DispatchQueue.main.async {
                    self?.loadingDoneCallback?()
                }
            }
        }
        
        deactivateDebugMode()
    }
    
    func deactivateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 43200
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func activateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func bool(forKey key: ValueKey) -> Bool {
        RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func string(forKey key: ValueKey) -> String {
        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func double(forKey key: ValueKey) -> Double {
        RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
    }
}
