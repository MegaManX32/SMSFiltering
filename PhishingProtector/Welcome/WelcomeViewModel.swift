//
//  WelcomeViewModel.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 12.12.24..
//

import Foundation

class WelcomeViewModel: ObservableObject {
    
    @Published private(set) var phishingDomains: [PhishingDomain]
    @Published var newDomainName: String = ""
    private let cache: PhishingCache
    
    init() {
        cache = PhishingCacheFactory.shared.phishingCache()
        phishingDomains = cache.domainCache
    }
    
    func addDomain() {
        let domain = PhishingDomain(name: newDomainName)
        cache.addDomain(domain)
        PhishingCacheFactory.shared.saveCache(cache)
        phishingDomains = cache.domainCache
        newDomainName = ""
    }
    
    func removeDomain(_ domain: PhishingDomain) {
        cache.removeDomain(domain)
        PhishingCacheFactory.shared.saveCache(cache)
        phishingDomains = cache.domainCache
    }
}
