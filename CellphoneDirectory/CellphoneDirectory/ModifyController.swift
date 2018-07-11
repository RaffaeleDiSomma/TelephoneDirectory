//
//  ModifyController.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 09/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

class ModifyController: UIViewController, UITextFieldDelegate {

    @IBOutlet var name: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var prefix: UITextField!
    @IBOutlet var phone: UITextField!
    
    
    @IBOutlet var errorNameEmpty: UILabel!
    @IBOutlet var errorSurnameEmpty: UILabel!
    @IBOutlet var errorPrefixFormat: UILabel!
    @IBOutlet var errorNumberEmpty: UILabel!
    @IBOutlet var errorMaxPhoneNumbers: UILabel!
    @IBOutlet var errorOnlyNumbers: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.autocapitalizationType = .words
        self.surname.autocapitalizationType = .words
        
        name.delegate = self
        surname.delegate = self
        prefix.delegate = self
        phone.delegate = self
        
        name.placeholder = contactsArray[positionToModify].name     //the placeholder is the actual name of the contact
        surname.placeholder = contactsArray[positionToModify].surname   // the placeholder is the actual surname of the contact
        let prf = contactsArray[positionToModify].phoneNumber.prefix(3) // take the prefix from the phone number
        prefix.placeholder = String(prf)    // the placeholder is the actual prefix of the contact
        
        let phoneLenght = contactsArray[positionToModify].phoneNumber.count - 3
        var phoneSuffix = contactsArray[positionToModify].phoneNumber.suffix(phoneLenght)   // take the phone number without the prefix
        let digitSet = CharacterSet.decimalDigits
        let correctPhone = String(phoneSuffix.unicodeScalars.filter {digitSet.contains($0)})
        
        phone.placeholder = correctPhone    // the placeholder is the actual phone number of the contact
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkPhoneNumber(prf: String, num: String) -> String { // check if the phone number is right
        let digitSet = CharacterSet.decimalDigits
        let correctPrf = String(prf.unicodeScalars.filter {digitSet.contains($0)})
        var prefixNumber: String = ""
        
        if prf.first == "+" && correctPrf.count == 2 {
            prefixNumber = String(prf.first!) + correctPrf
            errorPrefixFormat.isHidden = true
        } else {
            errorPrefixFormat.isHidden = false
            return "error"
        }
        
        
        if num.count > 8 {
            errorMaxPhoneNumbers.isHidden = false
            return "error"
        } else {
            errorMaxPhoneNumbers.isHidden = true
        }
        
        var firstPartNumber = num.prefix(2)
        var secondPartNumber: String = ""
        switch num.count {
        case 8:
            secondPartNumber = String(num.suffix(6))
        case 7:
            secondPartNumber = String(num.suffix(5))
        case 6:
            secondPartNumber = String(num.suffix(4))
        case 5:
            secondPartNumber = String(num.suffix(3))
        default:
            firstPartNumber = num.prefix(4)
            secondPartNumber = String(num.suffix(0))
        }
        
        if firstPartNumber.count == String(firstPartNumber.unicodeScalars.filter {digitSet.contains($0)}).count && secondPartNumber.count == String(secondPartNumber.unicodeScalars.filter {digitSet.contains($0)}).count {
            let finalNumber = prefixNumber + " " + firstPartNumber + " " + secondPartNumber
            errorOnlyNumbers.isHidden = true
            return finalNumber
        }
        else{
            errorOnlyNumbers.isHidden = false
            return "error"
        }
    }
    
    
    @IBAction func onClickSave(_ sender: Any) { // save function
        var contactPhoneNumber: String = ""
        var contactName: String = ""
        var contactSurname: String = ""
        
        // if a field is empty, it will be filled with the placeholder
        
        if phone.text?.isEmpty == false && prefix.text?.isEmpty == false {
        contactPhoneNumber = checkPhoneNumber(prf: prefix.text!, num: phone.text!)
        } else if phone.text?.isEmpty == true && prefix.text?.isEmpty == false {
            contactPhoneNumber = checkPhoneNumber(prf: prefix.text!, num: phone.placeholder!)
        } else if phone.text?.isEmpty == false && prefix.text?.isEmpty == true {
            contactPhoneNumber = checkPhoneNumber(prf: prefix.placeholder!, num: phone.text!)
        } else {
            contactPhoneNumber = checkPhoneNumber(prf: prefix.placeholder!, num: phone.placeholder!)
        }
        
        if name.text?.isEmpty == true {
            contactName = name.placeholder!
        } else {
            contactName = name.text!
        }
        
        if surname.text?.isEmpty == true {
            contactSurname = surname.placeholder!
        } else {
            contactSurname = surname.text!
        }
        
        if contactPhoneNumber != "error" {
        contactsArray[positionToModify].name = contactName
        contactsArray[positionToModify].surname = contactSurname
        contactsArray[positionToModify].phoneNumber = contactPhoneNumber
        
        searchArray = contactsArray
        _ = navigationController?.popToRootViewController(animated: true)   
        }
    }
}
