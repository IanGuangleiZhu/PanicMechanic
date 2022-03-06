//
//  Environment.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/30/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

enum PlistKey {
    case url
    case appName
    case version
    case bundleID
    case link
    case env
    case userCollection
    case episodeCollection
    
    func value() -> String {
        switch self {
        case .url:
            return "PMURL"
        case .appName:
            return "CFBundleName"
        case .version:
            return "CFBundleShortVersionString"
        case .bundleID:
            return "CFBundleIdentifier"
        case .link:
            return "PMLink"
        case .env:
            return "PMEnvironment"
        case .userCollection:
            return "PMCollectionUser"
        case .episodeCollection:
            return "PMCollectionEpisode"
        }
    }
}
//        let env = Environment().configuration(PlistKey.env)
struct Environment {
    
    private var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                print(dict)
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    func configuration(_ key: PlistKey) -> String {
        switch key {
        case .url:
            return infoDict[PlistKey.url.value()] as! String
        case .appName:
            return infoDict[PlistKey.appName.value()] as! String
        case .version:
            return infoDict[PlistKey.version.value()] as! String
        case .bundleID:
            return infoDict[PlistKey.bundleID.value()] as! String
        case .link:
            return infoDict[PlistKey.link.value()] as! String
        case .env:
            return infoDict[PlistKey.env.value()] as! String
        case .userCollection:
            return infoDict[PlistKey.userCollection.value()] as! String
        case .episodeCollection:
            return infoDict[PlistKey.episodeCollection.value()] as! String
        }
    }
}
