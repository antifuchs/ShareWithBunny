//
//  ViewController.swift
//  ShareWithBunny
//
//  Created by Andreas Fuchs on 12/31/16.
//  Copyright © 2016 Andreas Fuchs. All rights reserved.
//

import UIKit
import Social
import MessageUI
import Contacts
import ContactsUI
import SWBCommon

class ViewController: UIViewController, CNContactPickerDelegate {
    @IBAction func pickBunny(sender: AnyObject) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0 OR phoneNumbers.@count > 0")
        self.present(contactPicker, animated: true, completion: nil)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect theProp: CNContactProperty) {
        print("Selected!")
        print(theProp.value!)
        let defaults = UserDefaults(suiteName: SWBPreferenceGroup)
        if let phone = theProp.value! as? CNPhoneNumber {
            defaults?.set(phone.stringValue, forKey: SWBPreferences.SBBunnyProp.rawValue)
        } else {
            defaults?.set(theProp.value!, forKey: SWBPreferences.SBBunnyProp.rawValue)
        }
        defaults?.synchronize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

