//
//  SearchVC.swift
//  the-weather
//
//  Created by Mobile Jakarta Team on 05/03/18.
//  Copyright © 2018 moonshadow. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["Computer", "Laptop", "Handphone", "Tupperware"]
    
    var filteredData = [String]()
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.showsCancelButton = true
        self.enableSearchCancelButton(searchBar: searchBar)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        if isSearching {
            cell.configureCell(data: filteredData[indexPath.row])
        } else {
            cell.configureCell(data: data[indexPath.row])
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            print(filteredData[indexPath.row])
        } else {
            print(data[indexPath.row])
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = data.filter({$0.lowercased().contains(searchText.lowercased())})
            
            tableView.reloadData()
        }
    }
    
    func enableSearchCancelButton(searchBar: UISearchBar){
        for subView in searchBar.subviews {
            for view in subView.subviews {
                if view.isKind(of:NSClassFromString("UIButton")!) {
                    let cancelButton = view as! UIButton
                    print("cancelButton.isEnabled: \(cancelButton.isEnabled)")
                    cancelButton.isEnabled = true
                }
            }
        }
    }
}
