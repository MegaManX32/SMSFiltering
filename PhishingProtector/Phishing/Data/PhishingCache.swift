//
//  PhishingCache.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 11.12.24..
//

import Foundation

final class PhishingCache: Codable {
    private(set) var domainCache = [PhishingDomain]()
    
    init() {
        domainCache.append(PhishingDomain(name: "www.phishing.com"))
        domainCache.append(PhishingDomain(name: "www.phishing.net"))
    }
    
    func addDomain(_ domain: PhishingDomain) {
        domainCache.append(domain)
    }
    
    func removeDomain(_ domain: PhishingDomain) {
        domainCache = domainCache.filter { $0 != domain }
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
