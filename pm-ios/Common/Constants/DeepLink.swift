//
//  DeepLink.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/25/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

struct DeepLink {
    let dynamicLink: DynamicLink
}


struct DeepLinkURLConstants {
  static let Onboarding = "onboard"
  static let VerifyEmail = "emailVerification"
}

enum DeepLinkOption {

  case onboarding
  case verifyEmail


  static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL,
      let _ = URLComponents(url: url, resolvingAgainstBaseURL: false) {
      //TODO: extract string and match with DeepLinkURLConstants
    }
    return nil
  }

  static func build(with dict: [String : AnyObject]?) -> DeepLinkOption? {
    guard let id = dict?["launch_id"] as? String else { return nil }
    switch id {
      case DeepLinkURLConstants.Onboarding: return .onboarding
      case DeepLinkURLConstants.VerifyEmail: return .verifyEmail
      default: return nil
    }
  }
}




class EmailHandler {
    
    private let apiKey: String
    private let mode: HandlerMode
    private let oobCode: String
    private let continueURL: URL?
    private static let keys: [String] = ["apiKey", "mode", "oobCode", "continueUrl"]
    
    init?(queryItems: [URLQueryItem]) {
        var missingKeys: [String] = []
        for key in EmailHandler.keys {
            if let queryItem = queryItems.filter({ $0.name == key }).first {
                log.info("Query items contains:", context: [key, queryItem])
            } else {
                log.info("Query items is missing:", context: key)
                missingKeys.append(key)
            }
        }
        guard missingKeys.count == 0 else { return nil }
        let apiKey = queryItems.filter({ $0.name == "apiKey" }).first!.value!
        let mode = queryItems.filter({ $0.name == "mode" }).first!.value!
        let oobCode = queryItems.filter({ $0.name == "oobCode" }).first!.value!
        let continueUrlPath = queryItems.filter({ $0.name == "continueUrl" }).first!.value!
        
        self.apiKey = apiKey
        self.mode = HandlerMode(rawValue: mode)!
        self.oobCode = oobCode
        self.continueURL = URL(string: continueUrlPath)
    }
    
    func handleEmail() {
        switch mode {
        case .verifyEmail:
            return
        case .resetPassword:
            return
        case .recoverEmail:
            return
        }
    }
    
}

enum HandlerMode: String {
    case verifyEmail = "verifyEmail"
    case recoverEmail = "recoverEmail"
    case resetPassword = "resetPassword"
}
