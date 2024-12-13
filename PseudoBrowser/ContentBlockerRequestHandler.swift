//
//  ContentBlockerRequestHandler.swift
//  PseudoBrowser
//
//  Created by Vladislav Simovic on 13.12.24..
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    private enum ContentBlockerError: String, Error {
        case couldNotCreateNSItemWithUrl
    }
    
    func beginRequest(with context: NSExtensionContext) {
        do {
            let url = try PhishingCacheFactory.shared.blockedListURL()
            let item = try Self.extensionItemProvider(from: url)
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } catch {
            Logger.shared.log(message: error.localizedDescription, level: .error)
            context.completeRequest(returningItems: nil)
        }
    }
    
    private static func extensionItemProvider(from url: URL) throws -> NSExtensionItem {
        guard let attachment = NSItemProvider(contentsOf: url) else {
            throw ContentBlockerError.couldNotCreateNSItemWithUrl
        }
        Logger.shared.log(message: "Loaded blocked list with attachment: \(attachment)")
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        return item
    }
}
