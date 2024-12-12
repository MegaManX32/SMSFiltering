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
        ScrollView {
            VStack {
                ForEach(viewModel.phishingDomains) { domain in
                    WelcomeRow(text: domain.name) {
                        viewModel.removeDomain(domain)
                    }
                }
                WelcomeAddRow(newDomainName: $viewModel.newDomainName) {
                    viewModel.addDomain()
                }
                Spacer()
            }
        }
    }
}

struct WelcomeRow: View {
    let text: String
    let tapClosure: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 18))
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 8)
            
            Spacer()
            
            Button(action: {
                tapClosure?()
            }) {
                Label("", systemImage: "trash")
                    .foregroundStyle(.red)
            }
            .padding(.trailing, 16)
        }
    }
}

struct WelcomeAddRow: View {
    @Binding var newDomainName: String
    let tapClosure: (() -> Void)?
    
    var body: some View {
        HStack {
            TextField("Enter new domain", text: $newDomainName)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .multilineTextAlignment(.leading)
                .font(.system(size: 18))
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 8)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                })
                .padding([.leading, .trailing], 16)
            
            Button(action: {
                tapClosure?()
            }) {
                Label("", systemImage: "plus")
                    .foregroundStyle(.blue)
            }
            .padding([.leading, .trailing], 16)
        }
    }
}

#Preview {
    WelcomeView(viewModel: WelcomeViewModel())
}
