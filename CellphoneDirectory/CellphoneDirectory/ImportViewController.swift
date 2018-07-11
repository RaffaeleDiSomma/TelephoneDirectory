//
//  ImportViewController.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 10/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController, UITableViewDataSource {
    
    

    @IBOutlet weak var importTable: UITableView!
    
    override func viewDidLoad() {
        importTable.reloadData()
        super.viewDidLoad()

       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phonebook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let importCell = tableView.dequeueReusableCell(withIdentifier: "ImportCell") as? ImportTableViewCell else {
            return UITableViewCell()
        }
        importCell.importedName.text = phonebook[indexPath.row].name + " " + phonebook[indexPath.row].surname
        importCell.importedPhone.text = phonebook[indexPath.row].phoneNumber
        
        return importCell
    }
    

    @IBAction func onClickRefresh(_ sender: Any) {
        importTable.reloadData()
    }
    

}
