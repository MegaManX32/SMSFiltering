//
//  zd.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 12.12.24..
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject private var viewModel: WelcomeViewModel
    
    init(viewModel: WelcomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.phishingDomains) { domain in
                Text(domain.name)
            }
        }
    }
}

#Preview {
    WelcomeView(viewModel: WelcomeViewModel())
}
