//
//  AddUpdateContactViewController.swift
//  TapCode
//
//  Created by Mark Lindamood on 12/12/15.
//  Copyright © 2015 Mark Lindamood. All rights reserved.
//


import UIKit
import Contacts
import ContactsUI

class AddUpdateViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    var contactStore = CNContactStore()
    var updateContact = CNContact()
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Done, target: self, action: nil)
        
    }
    
    //MARK: Create a new person
    // Called when users tap "Create New Contact" in the application. Allows users to create a new contact.
    private func showNewContactViewController() {
        let npvc = CNContactViewController(forNewContact: nil)
        npvc.delegate = self
        
        //npvc.contactStore = self.store //seems to work without setting this.
        let navigation = UINavigationController(rootViewController: npvc)
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    //MARK: Display and edit a person
    // Called when users tap "Display and Edit Contact" in the application. Searches for a contact named "Appleseed" in
    // in the address book. Displays and allows editing of all information associated with that contact if
    // the search is successful. Shows an alert, otherwise.
    private func showContactViewController(name: String) {
        // Search for the person named "Appleseed" in the Contacts
        //let name = contact.familyName
        let predicate: NSPredicate = CNContact.predicateForContactsMatchingName(name)
        let descriptor = CNContactViewController.descriptorForRequiredKeys()
        let contacts: [CNContact]
        do {
            contacts = try contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: [descriptor])
        } catch {
            contacts = []
        }
        // Display information  found in the address book
        if !contacts.isEmpty {
            let contact = contacts[0]
            let cvc = CNContactViewController(forContact: contact)
            cvc.delegate = self
            // Allow users to edit the person’s information
            cvc.allowsEditing = true
            //cvc.contactStore = self.store //seems to work without setting this.
            self.navigationController?.pushViewController(cvc, animated: true)
        } else {
            // Show an alert if "Appleseed" is not in Contacts
            let alert = UIAlertController(title: "Error",
                message: "Could not find \(name) in the Contacts application.",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}


   