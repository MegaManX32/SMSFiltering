//
//  WelcomeViewController.swift
//  SMSFiltering
//
//  Created by Vladislav Simovic on 9.12.24..
//

import UIKit
import os
import SwiftUI

class WelcomeViewController: UIHostingController<WelcomeView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: WelcomeView(viewModel: WelcomeViewModel()))
    }
}

