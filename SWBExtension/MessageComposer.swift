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

let attachableContentTypes = [kUTTypeImage, kUTTypeInternetLocation, kUTTypeAudiovisualContent, kUTTypeVCard, kUTTypeCalendarEvent, kUTTypeMessage]
let textContentTypes = [kUTTypeURL, kUTTypeText]

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    open var sentDelegator: MessageSentDelegator? = nil
    var firstAttachment = true
    
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
        // print(attachment.registeredTypeIdentifiers)
        if let type =  attachmentContentType(attachment, fromTypes: attachableContentTypes) {
            attachment.loadItem(forTypeIdentifier: type, options: nil) { data, error in
                if let url = data as? NSURL {
                    controller.addAttachmentURL(url as URL, withAlternateFilename: nil)
                } else if let nsdata = data as? Data {
                    // TODO: filename is wrong, but it doesn't seem to matter.
                    controller.addAttachmentData(nsdata, typeIdentifier: type, filename: "bunny-content.data")
                }
                execute()
            }
        } else if let type = attachmentContentType(attachment, fromTypes: textContentTypes) {
            attachment.loadItem(forTypeIdentifier: type, options: nil) { data, error in
                var text = ""
                if let url = data as? NSURL {
                    text = (url.absoluteString)!
                } else {
                    text = data as! String
                }
                if !self.firstAttachment {
                    controller.body?.append("\n")
                }
                self.firstAttachment = false
                controller.body?.append(text)
            }
            execute()
        } else {
            // TODO: We should handle all possible content types, but fall through for now.
            execute()
        }
    }
    
    func attachmentContentType(_ attachment: NSItemProvider, fromTypes: [CFString]) -> String? {
        for type in fromTypes {
            if attachment.hasItemConformingToTypeIdentifier(type as String) {
                return type as String
            }
        }
        return nil
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
