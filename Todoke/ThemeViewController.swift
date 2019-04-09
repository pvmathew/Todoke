//
//  ThemeViewController.swift
//  Todoke
//
//  Created by Pavin Mathew on 4/8/19.
//  Copyright © 2019 Pavin Mathew. All rights reserved.
//

import UIKit

class ThemeViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        self.title = "Themes"
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        if (UserDefaults.standard.integer(forKey: "theme")) == 1 { //Light Theme
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
            tableView.backgroundColor = .white
            tableView.separatorColor = .lightGray
        } else { //Dark Theme
            cell.backgroundColor = .lead()
            cell.textLabel?.textColor = .white
            tableView.backgroundColor = .lead()
            tableView.separatorColor = .darkGray
        }
        
        if indexPath.row == UserDefaults.standard.integer(forKey: "theme") {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Dark (Default)"
        case 1:
            cell.textLabel?.text = "Light"
        default:
            print("Finished loading themeView cells")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "theme")
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
