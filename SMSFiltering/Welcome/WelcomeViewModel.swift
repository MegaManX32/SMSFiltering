//
//  WelcomeViewModel.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 12.12.24..
//

import Foundation

class WelcomeViewModel: ObservableObject {
    
    @Published private(set) var phishingDomains: [PhishingDomain]
    
    init() {
        phishingDomains = PhishingCacheFactory.shared.phishingCache().domainCache
    }
    
    func addDomain(_ domain: String) {
        
    }
}
