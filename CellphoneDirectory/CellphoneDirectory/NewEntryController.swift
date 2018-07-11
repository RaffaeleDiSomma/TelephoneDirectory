//
//  ViewController.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 07/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit
import Contacts

class Contact {         // the class that handles the entries
    var name: String
    var surname: String
    var phoneNumber: String
    init(name: String, surname: String, phoneNumber: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
    }
}

var contactsArray: [Contact] = []   // array in which I put all the entries
var searchArray : [Contact] = []    // array that I used to filter the search
var phonebook : [Contact] = []      // array in wich I put all the contacts that i can import

class NewEntryController: UIViewController, UITextFieldDelegate{
    
    // fields to fill
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var prefix: UITextField!
    
                                                        // allerts to display if the user doesn't fill the fields in the correct way
    @IBOutlet weak var errorNumberEmpty: UILabel!
    @IBOutlet weak var errorMaxPhoneNumbers: UILabel!
    @IBOutlet weak var errorPrefixFormat: UILabel!
    @IBOutlet weak var errorNameEmpty: UILabel!
    @IBOutlet weak var errorSurnameEmpty: UILabel!
    @IBOutlet weak var errorOnlyNumbers: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.autocapitalizationType = .words
        self.surname.autocapitalizationType = .words
        
        name.delegate = self
        surname.delegate = self
        phone.delegate = self
        prefix.delegate = self
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
    func checkPhoneNumber(prf: String, num: String) -> String {
        let digitSet = CharacterSet.decimalDigits       //decimal numbers
        let correctPrf = String(prf.unicodeScalars.filter {digitSet.contains($0)})  // filter the prefix to be sure that there are no letters or symbols inside it
        var prefixNumber: String = ""
        
        if prf.first == "+" && correctPrf.count == 2 {
            prefixNumber = String(prf.first!) + correctPrf  //build the prefix
            errorPrefixFormat.isHidden = true
        } else {
            errorPrefixFormat.isHidden = false
            return "error"
        }
    
        
        if num.count > 8 {         // the phone number should have 2 numbers, a space, and other 6 numbers, so max 8 numbers
            errorMaxPhoneNumbers.isHidden = false
            return "error"
        } else if num.isEmpty == true {     // the phone number can't be empty
            errorNumberEmpty.isHidden = false
            return "error"
        } else {
            errorMaxPhoneNumbers.isHidden = true
            errorNumberEmpty.isHidden = true
        }
        
        
        var firstPartNumber = num.prefix(2)
        var secondPartNumber: String = ""
        switch num.count {                      // separating the number into two parts
        case 8:
            secondPartNumber = String(num.suffix(6))
        case 7:
            secondPartNumber = String(num.suffix(5))
        case 6:
            secondPartNumber = String(num.suffix(4))
        case 5:
            secondPartNumber = String(num.suffix(3))
        default:
            firstPartNumber = num.prefix(4)        // if there are only 4 numbers, there is no separation
            secondPartNumber = String(num.suffix(0))
        }
        
        
        
        if firstPartNumber.count == String(firstPartNumber.unicodeScalars.filter {digitSet.contains($0)}).count && secondPartNumber.count == String(secondPartNumber.unicodeScalars.filter {digitSet.contains($0)}).count {   // if the phone number is made only by numbers
            let finalNumber = prefixNumber + " " + firstPartNumber + " " + secondPartNumber  // build the final phone number
            errorOnlyNumbers.isHidden = true
            return finalNumber
        }
        else{
            errorOnlyNumbers.isHidden = false
            return "error"
        }
    }
    
    func checkName(name: String) -> String {    // check that the name is not empty
        if name.isEmpty == true {
            errorNameEmpty.isHidden = false
            return "error"
        } else {
            errorNameEmpty.isHidden = true
            return name
        }
    }
    
    func checkSurname(surname: String) -> String {  // check that the surname is not empty
        if surname.isEmpty == true {
            errorSurnameEmpty.isHidden = false
            return "error"
        } else {
            errorSurnameEmpty.isHidden = true
            return surname
        }
    }
    
    @IBAction func onClickSave(_ sender: Any) {     // save function
        
        let contactPhoneNumber = checkPhoneNumber(prf: prefix.text!, num: phone.text!)
        let contactName = checkName(name: name.text!)
        let contactSurname = checkSurname(surname: surname.text!)
        
        
        if contactPhoneNumber != "error" && contactName != "error" && contactSurname != "error"{
            contactsArray.append(Contact(name: contactName, surname: contactSurname, phoneNumber: contactPhoneNumber))  //add the contact to the array
            
        searchArray = contactsArray
        _ = navigationController?.popToRootViewController(animated: true)   // return to the root view controller
            
            
        }
    }
    @IBAction func onClickImport(_ sender: Any) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access!", err)
                return
            }
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with:  request, usingBlock: { (contact, stopPointer) in
                       
                        
                        phonebook.append(Contact(name: contact.givenName, surname: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? ""))
                        
                        
                    })
                    
                } catch let err {
                    print("Failed to enumerate contacts:", err)
                }
                
                
            } else {
                print("Access denied")
            }
        }
        
        
      //  popUpTable.reloadData()
    }
    
    
    
  
    
}

