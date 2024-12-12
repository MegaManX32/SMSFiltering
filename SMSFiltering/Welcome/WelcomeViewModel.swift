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
    
    init() {
        phishingDomains = PhishingCacheFactory.shared.phishingCache().domainCache
    }
    
    func addDomain() {
        phishingDomains.append(PhishingDomain(name: newDomainName))
        newDomainName = ""
    }
    
    func removeDomain(_ domain: PhishingDomain) {
        phishingDomains = phishingDomains.filter { $0 != domain }
    }
}
