//
//  MessageComposer.swift
//  ShareWithBunny
//
//  Created by Andreas Fuchs on 12/31/16.
//  Copyright © 2016 Andreas Fuchs. All rights reserved.
//

import Foundation
import MobileCoreServices
import MessageUI
import SWBCommon

let attachableContentTypes = [kUTTypeImage, kUTTypeInternetLocation, kUTTypeVideo]

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    open var sentDelegator: MessageSentDelegator? = nil
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }

    func configuredMessageComposeViewController(_ contents: [NSItemProvider], recipient: String, execute: @escaping (MFMessageComposeViewController) -> ()) {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = [recipient]
        messageComposeVC.body = ""
        
        let myGroup = DispatchGroup()
        for attachment in contents {
            myGroup.enter()
            addAttachment(attachment: attachment, controller: messageComposeVC, execute: {
                myGroup.leave()
            })
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            execute(messageComposeVC)
        })
    }
    
    func addAttachment(attachment: NSItemProvider, controller: MFMessageComposeViewController, execute: @escaping ()->()) {
        if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
            attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { data, error in
                let url = data as! NSURL
                controller.addAttachmentURL(url as URL, withAlternateFilename: nil)
                execute()
            }
        } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
            var first = true
            attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { data, error in
                let url = data as! NSURL
                let urlText = (url.absoluteString)!
                if !first {
                    controller.body?.append("\n")
                }
                controller.body?.append(urlText)
                first = false
            }
            execute()
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if result == MessageComposeResult.sent {
            self.sentDelegator?.messageSent()
        } else {
            self.sentDelegator?.messageComposerDismissed()
        }
    }
}
