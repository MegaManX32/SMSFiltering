//
//  PhishingFactory.swift
//  PhishingProtector
//
//  Created by Vladislav Simovic on 13.12.24..
//

import Foundation
import SafariServices

final class PhishingCacheFactory {
    
    private enum Constants {
        static let suiteName = "group.com.simke.phishingprotector.shared"
        static let cacheKey = "phishing.cache"
        static let contentBlockerPath = "blockerList.json"
        static let pseudoBrowserBundle = "com.simke.PhishingProtector.PseudoBrowser"
    }
    
    private enum PhishingCacheError: String, Error {
        typealias RawValue = String
        
        case cacheDataCouldNotBeRetrieved
        case sharedContainerNotFound
        case blockerFileNotFound
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
    
    func saveCache(_ cache: PhishingCache) {
        do {
            let data = try encoder.encode(cache)
            storeDataToSuite(data)
            updateContentBlocker(with: cache)
            Logger.shared.log(message: "Cache saved")
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
        }
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

    private func updateContentBlocker(with cache: PhishingCache) {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.suiteName)
        guard let container else {
            Logger.shared.log(message: "Shared container not found", level: .error)
            return
        }
        let rules = cache.domainCache.map { ContentBlockerRule(domain: $0.name) }
        
        do {
            let data = try encoder.encode(rules)
            let blockerPath = container.appendingPathComponent(Constants.contentBlockerPath)
            try data.write(to: blockerPath, options: .atomic)
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: Constants.pseudoBrowserBundle)
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
        }
    }
    
    func blockedListURL() throws -> URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.suiteName)
        guard let container else {
            throw PhishingCacheError.sharedContainerNotFound
        }
        let blockerPath = container.appendingPathComponent(Constants.contentBlockerPath)
        if FileManager.default.fileExists(atPath: blockerPath.path) {
            return blockerPath
        } else {
            throw PhishingCacheError.blockerFileNotFound
        }
    }
}
