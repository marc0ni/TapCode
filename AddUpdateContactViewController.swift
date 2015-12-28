//
//  AddContactViewController.swift
//  TapCode
//
//  Created by Mark Lindamood on 12/12/15.
//  Copyright © 2015 Mark Lindamood. All rights reserved.
//


import UIKit
import Contacts
import ContactsUI

class AddViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {
    
    var store = CNContactStore()
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createContact() {
        let fooBar = CNMutableContact()
        fooBar.givenName = "Foo"
        fooBar.middleName = "A."
        fooBar.familyName = "Bar"
        fooBar.nickname = "Fooboo"
        
        //profile photo
        if let img = UIImage(named: "apple"),
            let data = UIImagePNGRepresentation(img){
                fooBar.imageData = data
        }
        
        //set the phone numbers
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: "123"))
        let workPhone = CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: "567"))
        fooBar.phoneNumbers = [homePhone, workPhone]
        
        //set the email addresses
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: "foo@home")
        let workEmail = CNLabeledValue(label: CNLabelWork, value: "foo@work")
        fooBar.emailAddresses = [homeEmail, workEmail]
        
        //job info
        fooBar.jobTitle = "Chief Awesomeness Manager (CAM)"
        fooBar.organizationName = "Pixolity"
        fooBar.departmentName = "IT"
        
        //social media
        let facebookProfile = CNLabeledValue(label: "FaceBook", value: CNSocialProfile(urlString: nil, username: "foobar", userIdentifier: nil, service: CNSocialProfileServiceFacebook))
        let twitterProfile = CNLabeledValue(label: "Twitter", value: CNSocialProfile(urlString: nil, username: "foobar", userIdentifier: nil, service: CNSocialProfileServiceTwitter))
        fooBar.socialProfiles = [facebookProfile, twitterProfile]
        
        //instant messaging
        let skypeAddress = CNLabeledValue(label: "Skype", value: CNInstantMessageAddress(username: "foobar", service: CNInstantMessageServiceSkype))
        let aimAddress = CNLabeledValue(label: "AIM", value: CNInstantMessageAddress(username: "foobar", service: CNInstantMessageServiceAIM))
        fooBar.instantMessageAddresses = [skypeAddress, aimAddress]
        
        //some additional notes
        fooBar.note = "Some additional notes"
        
        //birthday
        let birthday = NSDateComponents()
        birthday.year = 1980
        birthday.month = 9
        birthday.day = 27
        fooBar.birthday = birthday
        
        //anniversary
        let anniversaryDate = NSDateComponents()
        anniversaryDate.month = 6
        anniversaryDate.day = 13
        let anniversary = CNLabeledValue(label: "Anniversary", value: anniversaryDate)
        fooBar.dates = [anniversary]
        
        //finally save
        let request = CNSaveRequest()
        request.addContact(fooBar, toContainerWithIdentifier: nil)
        do {
            try store.executeSaveRequest(request)
            print("Successfully  stored the contact")
        } catch let err {
            print("Failed to save the contact. \(err)")
        }
    }
    
    
    // MARK: - Contact Access Permission Method
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatusForEntityType(. Contacts) {
        case .Authorized:
            createContact()
            
        case .NotDetermined:
            store.requestAccessForEntityType(. Contacts){ succeeded, err in
                guard err == nil && succeeded else {
                    return
                 }
                self.createContact()
            }
        default: print(" Not handled")
        }
    }
    
        


       
            
    
    /*private func requestContactsAccess() {
        
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
    }*/

    
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
    /*private func showContactViewController(name: String) {
        // Search for the person named "Appleseed" in the Contacts
        let name = contact.familyName
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
    }*/

}


   