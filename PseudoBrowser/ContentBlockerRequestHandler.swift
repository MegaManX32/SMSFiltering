//
//  ContentBlockerRequestHandler.swift
//  PseudoBrowser
//
//  Created by Vladislav Simovic on 13.12.24..
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        do {
            let url = try PhishingCacheFactory.shared.blockedListURL()
            let attachment = NSItemProvider(contentsOf: url)!
            let item = NSExtensionItem()
            item.attachments = [attachment]
            Logger.shared.log(message: "Loaded blocked list with attachment: \(attachment)")
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
            context.completeRequest(returningItems: nil)
        }
    }
}
