//
//  ShareViewController.swift
//  SWBExtension
//
//  Created by Andreas Fuchs on 12/31/16.
//  Copyright © 2016 Andreas Fuchs. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import SWBCommon

class ShareViewController: UIViewController, MessageSentDelegator {
    @IBOutlet weak var status: UILabel!
    
    var messageComposer: MessageComposer = MessageComposer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.status.becomeFirstResponder()
        self.shareAttachments()
    }
    
    func shareAttachments() {
        // Make sure we have a valid extension item
        if let recipient = self.configuredRecipient() {
            if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
                // Obtain a configured MFMessageComposeViewController
                if let contents = content.attachments as? [NSItemProvider] {
                    messageComposer.configuredMessageComposeViewController(contents, recipient: recipient, execute: { messageComposeVC in
                        // Present the configured MFMessageComposeViewController instance
                        // Note that the dismissal of the VC will be handled by the messageComposer instance,
                        // since it implements the appropriate delegate call-back
                        if (self.messageComposer.canSendText()) {
                            self.messageComposer.sentDelegator = self
                            
                            self.present(messageComposeVC, animated: true, completion: nil)
                        } else {
                            // Let the user know if his/her device isn't able to send text messages
                            let alert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Fine. It's ok.", style: UIAlertActionStyle.default, handler: { _ in
                                // Unblock the UI.
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func configuredRecipient() -> String? {
        let defaults = UserDefaults(suiteName: SWBPreferenceGroup)
        defaults?.synchronize()
        
        // Check for null value before setting
        if let restoredValue = defaults!.string(forKey: SWBPreferences.SBBunnyProp.rawValue) {
            return restoredValue
        }
        else {
            // Let the user know if his/her device isn't able to send text messages
            let alert = UIAlertController(title: "Not yet configured", message: "We haven't set the person to send to yet. Please launch Send To Bunny and set them.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                // Unblock the UI.
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            return nil
        }
    }

    func messageComposerDismissed() {
        // Unblock the UI.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func messageSent() {
        self.status.text = "🐰✅"
        // Unblock the UI.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
