//
//  ImportTableViewCell.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 10/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

var positionToAdd: Int = 0

class ImportTableViewCell: UITableViewCell {

    @IBOutlet var importedName: UILabel!
    @IBOutlet var importedPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func onClickImportContact(_ sender: Any) {
        let phoneNumber = self.importedPhone.text
        
        for contacts in 0 ... phonebook.count - 1 {
            if phonebook[contacts].phoneNumber == phoneNumber {
                    positionToAdd = contacts
                
            }
        }
    }
    
}
