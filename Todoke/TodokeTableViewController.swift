//
//  TodokeTableViewController.swift
//  Todoke
//
//  Created by Pavin Mathew on 3/23/19.
//  Copyright © 2019 Pavin Mathew. All rights reserved.
//

import UIKit
import CoreData


class TodokeTableViewController: UITableViewController {
    
    var allTasks: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    var taskTextField: UITextField!
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Task", message: "What needs doing?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: self.saveTask)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: { (textField) in
            self.taskTextField = textField
            textField.placeholder = "Enter task here"}) //**
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTask(alert: UIAlertAction!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        
        // Create a task model object from entity and insert into context
        let taskObject = NSManagedObject(entity: entity, insertInto: context)
        // Set title value for task object
        taskObject.setValue(taskTextField.text, forKey: "title")
        
        do {
            // Save changes in context to write them to disk
            try context.save()
            // And add newly created task object to array allTasks
            allTasks.append(taskObject)
        } catch {
            print("Core Data save failure")
        }
        
        // Table feed needs to be reloaded after adding a new task
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = allTasks[indexPath.row].value(forKey: "title") as? String
        return cell
    }
}

extension UINavigationController {
    // Ask top controller for its status bar style and update accordingly
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
