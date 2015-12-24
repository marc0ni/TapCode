//
//  SearchContactViewController.swift
//  TapCode
//
//  Created by Mark Lindamood on 12/12/15.
//  Copyright © 2015 Mark Lindamood. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

@IBOutlet weak var fullNameLabel: UILabel!
class ContactCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}



class SearchContactViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var sbContacts: UISearchBar!
    @IBOutlet weak var tbContacts: UITableView!
    
    var marrContacts = NSMutableArray()
    var contactStore = CNContactStore.self
    var updateContact = CNContact()
    
    // MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //askForContactAccess()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OpenUpdateContactView" {
            let addUpdateContactViewController = segue.destinationViewController as! AddUpdateContactViewController
            addUpdateContactViewController.updateContact = updateContact
            addUpdateContactViewController.isUpdate = true
        }
    }
    
    @IBAction func btnUpdateContactClicked(sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    // MARK: - Contact Access Permission Method
    /*func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
                            }
                            
                            alertController.addAction(dismissAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                }
            })
            break
        default:
            break
        }
    }
    
    // MARK: - Contact Select Method
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        updateContact = contact
        self.dismissViewControllerAnimated(false, completion: nil)
        performSegueWithIdentifier("OpenUpdateContactView", sender: nil)
    }*/

    
    // MARK: - UITableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrContacts.count
    }
    
    func tableView(tableView: UITableView, cellFoRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell")
        let contact = marrContacts.objectAtIndex(indexPath.row) as! CNContact
        cell!.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell!.detailTextLabel?.text = ""
        for phoneNo in contact.phoneNumbers {
            if phoneNo.label == CNLabelPhoneNumberMobile {
                cell!.detailTextLabel?.text = (phoneNo.value as! CNPhoneNumber).stringValue
                break
            }
        }
        
        return cell!
    }
    
    // MARK: - UISearchBar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchContactDataBaseOnName(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        marrContacts.removeAllObjects()
        tbContacts.reloadData()
    }
    
    // MARK: - Search Contact Methods
    func searchContactDataBaseOnName(name: String) {
        marrContacts.removeAllObjects()
        
        let predicate = CNContact.predicateForContactsMatchingName(name)
        
        //Fetch Contacts Information like givenName and familyName, phoneNo, address
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey]
        
        let store = CNContactStore()
        
        do {
            let contacts = try store.unifiedContactsMatchingPredicate(predicate,
                keysToFetch: keysToFetch)
            
            for contact in contacts {
                marrContacts.addObject(contact)
            }
            tbContacts.reloadData()
        }
        catch{
            print("Can't Search Contact Data")
        }
    }
}