//
//  AddImportedViewController.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 11/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

class AddImportedViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var phone: UITextField!
    @IBOutlet var prefix: UITextField!
    @IBOutlet var name: UITextField!    
    @IBOutlet var surname: UITextField!
    
    
    @IBOutlet var errorMaxNumbers: UILabel!
    @IBOutlet var errorOnlyNumbers: UILabel!
    @IBOutlet var errorNumberEmpty: UILabel!
    @IBOutlet var errorPrefixFormat: UILabel!
    @IBOutlet var errorSurnameEmpty: UILabel!
    @IBOutlet var errorNameEmpty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.autocapitalizationType = .words
        self.surname.autocapitalizationType = .words
        
        name.delegate = self
        surname.delegate = self
        prefix.delegate = self
        phone.delegate = self
        
        name.placeholder = phonebook[positionToAdd].name
        
        surname.placeholder = phonebook[positionToAdd].surname
        
        let digitSet = CharacterSet.decimalDigits
        if phonebook[positionToAdd].phoneNumber.first == "+" {
            prefix.placeholder = String(phonebook[positionToAdd].phoneNumber.prefix(3))
           let correctPhone = String(phonebook[positionToAdd].phoneNumber.suffix(phonebook[positionToAdd].phoneNumber.count - 3))
            phone.placeholder = String(correctPhone.unicodeScalars.filter { digitSet.contains($0)})
        } else {
            prefix.placeholder = ""
            phone.placeholder = phonebook[positionToAdd].phoneNumber
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkPhoneNumber(prf: String, num: String) -> String {
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
            errorMaxNumbers.isHidden = false
            return "error"
        } else {
            errorMaxNumbers.isHidden = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onClickSave(_ sender: Any) {
        var contactPhoneNumber: String = ""
        var contactName: String = ""
        var contactSurname: String = ""
        
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
            contactsArray.append(Contact(name: contactName, surname: contactSurname, phoneNumber: contactPhoneNumber))
            
            searchArray = contactsArray
            _ = navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}
