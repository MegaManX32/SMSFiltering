//
//  MessageFilterExtension.swift
//  SMSFilterExtension
//
//  Created by Vladislav Simovic on 9.12.24..
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest,
                context: ILMessageFilterExtensionContext,
                completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        let response = ILMessageFilterCapabilitiesQueryResponse()
        Logger.shared.log(message: "Start SMS filtering")
        completion(response)
    }
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest,
                context: ILMessageFilterExtensionContext,
                completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        
        let response = ILMessageFilterQueryResponse()
        let sender = queryRequest.sender
        let body = queryRequest.messageBody
        let cache = PhishingCacheFactory.shared.phishingCache()
        
        var bodyIsPhis = false
        if let body {
            bodyIsPhis = cache.isPhishing(with: body)
        }
        
        if bodyIsPhis {
            Logger.shared.log(message: "Message is potential phishing")
            response.action = .junk
        } else {
            Logger.shared.log(message: "Message is OK")
            response.action = .allow
        }
        completion(response)
    }
}
