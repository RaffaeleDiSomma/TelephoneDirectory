//
//  ViewController.swift
//  CellphoneDirectory
//
//  Created by Raffaele Di Somma on 08/07/18.
//  Copyright © 2018 Raffaele Di Somma. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.separatorColor = UIColor.clear   //remove the separator between the cells of the tableview
       
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        table.isHidden = true
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        
        
        alterLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func alterLayout() {    // add the searchbar on the navigation controller as title of the home page
        table.tableHeaderView = UIView()
        navigationItem.titleView = searchBar
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {   //number of cells
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    // showing contacts' data on the cells of the tableview
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = searchArray[indexPath.row].name + " " + searchArray[indexPath.row].surname
        cell.phoneLabel.text = searchArray[indexPath.row].phoneNumber
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {   // tapping on the searchbar the tableview will reload the datas and show the contacts
        table.reloadData()
        if searchArray.count != 0 {
            table.isHidden = false
        }
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {    // filtered search
        guard !searchText.isEmpty else {
            searchArray = contactsArray
            table.reloadData()
            return
        }
        searchArray = contactsArray.filter({ contact -> Bool in
            contact.name.lowercased().contains(searchText.lowercased()) || contact.surname.lowercased().contains(searchText.lowercased()) || contact.phoneNumber.contains(searchText)
        })
        table.reloadData()
    }
}
