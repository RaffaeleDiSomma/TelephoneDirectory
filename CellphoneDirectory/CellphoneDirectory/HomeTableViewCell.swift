//
//  TableViewCell.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 08/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

var positionToModify:Int = 0

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func onClickEdit(_ sender: Any) {     // used to take the index of the position of the entry to modify
    
        let phoneNumber = self.phoneLabel.text
        
        for contacts in 0 ... contactsArray.count - 1 {
            if contactsArray[contacts].phoneNumber == phoneNumber {
                if nameLabel.text == contactsArray[contacts].name + " " + contactsArray[contacts].surname {
                    positionToModify = contacts
                }
            }
        }
    }
}
