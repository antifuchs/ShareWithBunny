//
//  MessageSentDelegator.swift
//  ShareWithBunny
//
//  Created by Andreas Fuchs on 12/31/16.
//  Copyright © 2016 Andreas Fuchs. All rights reserved.
//

import Foundation

protocol MessageSentDelegator {
    func messageComposerDismissed()
    func messageSent()
}
