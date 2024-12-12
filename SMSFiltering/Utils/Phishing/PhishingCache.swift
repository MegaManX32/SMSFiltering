//
//  PhishingCache.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 11.12.24..
//

import Foundation

struct PhishingDomain: Codable, Identifiable, Equatable {
    let name: String
    var id: String { name }
}

final class PhishingCache: Codable {
    private(set) var domainCache = [PhishingDomain]()
    
    init() {
        domainCache.append(PhishingDomain(name: "www.phishing.com"))
        domainCache.append(PhishingDomain(name: "www.phishing.net"))
    }
    
    func isPhishing(with body: String) -> Bool {
        for key in domainCache.map({ $0.name }) {
            if body.contains(key) {
                return true
            }
        }
        return false
    }
}

final class PhishingCacheFactory {
    
    private enum Constants {
        static let suiteName = "group.com.simke.smsfiltering"
        static let cacheKey = "pshishingCache"
    }
    
    private enum PhishingCacheError: String, Error {
        typealias RawValue = String
        
        case cacheDataCouldNotBeRetrieved
    }
    
    static let shared = PhishingCacheFactory()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func phishingCache() -> PhishingCache {
        do {
            let data = try dataFromSuite()
            let cache = try decoder.decode(PhishingCache.self, from: data)
            Logger.shared.log(message: "Cache found")
            return cache
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
        }
        
        let cache = PhishingCache()
        do {
            let data = try encoder.encode(cache)
            storeDataToSuite(data)
            Logger.shared.log(message: "Cache created")
            
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
        }
        
        return cache
    }
    
    private func dataFromSuite() throws -> Data {
        guard let data = UserDefaults(suiteName: Constants.suiteName)?.data(forKey: Constants.cacheKey) else {
            throw PhishingCacheError.cacheDataCouldNotBeRetrieved
        }
        return data
    }
    
    private func storeDataToSuite(_ data: Data) {
        UserDefaults(suiteName: Constants.suiteName)?.set(data, forKey: Constants.cacheKey)
    }
}

