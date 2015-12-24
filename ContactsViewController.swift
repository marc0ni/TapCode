//
//  ContactsViewController.swift
//  TapCode
//
//  Created by Mark Lindamood on 12/11/15.
//  Copyright © 2015 Mark Lindamood. All rights reserved.
//


import UIKit
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    var contactStore = CNContactStore()
    var updateContact = CNContact()
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItemStyle.Done, target: self, action: nil)
        
        requestContactsAccess()
    }
    
    
    // MARK: - Contact Access Permission Method
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
            // Update our UI if the user has granted access to their Contacts
        case .Authorized:
            self.accessGrantedForContacts()
            
            // Prompt the user for access to Contacts if there is no definitive answer
        case .NotDetermined :
            self.requestContactsAccess()
            
            // Display a message if the user has denied or restricted access to Contacts
        case .Denied,
        .Restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                message: "Permission was not granted for Contacts.",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func requestContactsAccess() {
        
        contactStore.requestAccessForEntityType(.Contacts) {granted, error in
            if granted {
                dispatch_async(dispatch_get_main_queue()) {
                    self.accessGrantedForContacts()
                    return
                }
            }
        }
    }
    
    
    
    // This method is called when the user has granted access to their address book data.
    private func accessGrantedForContacts() {
        self.showContactPickerController()
    }
    
    
    //MARK: Show all contacts
    // Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
    // The application only shows the phone, email, and birthdate information of the selected contact.
    func showContactPickerController() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        
        // Display only a person's phone, email, and birthdate
        let displayedItems = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactBirthdayKey]
        picker.displayedPropertyKeys = displayedItems
        
        // Show the picker
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Contact Select Method
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        updateContact = contact
        self.dismissViewControllerAnimated(false, completion: nil)
        performSegueWithIdentifier("OpenUpdateContactView", sender: nil)
    }
}