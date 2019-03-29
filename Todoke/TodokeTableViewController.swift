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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.lead()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Define fetch request for Task objects
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            // Attempts fetch
            allTasks = try context.fetch(fetchRequest)
        } catch {
            print("Core Data load failure")
        }
    
        // When app is being reopened
    }
    
    // MARK: - New Task Functions
    
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
        
    }
    
    // MARK: - Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = allTasks[indexPath.row].value(forKey: "title") as? String
        cell.backgroundColor = UIColor.lead()
        cell.textLabel?.textColor = UIColor.white
        cell.accessoryView?.tintColor = UIColor.darkGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(allTasks[indexPath.row])
            allTasks.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                print("Core Data deletion failure")
            }
            tableView.reloadData()
        }
    }
    
    // TODO: - Single button that deletes all tasks
    // TODO: - Multiple pages/sections for different types of tasks
    // TODO: - Settings menu with option to change theme
    // TODO: - DatePickerView to set deadline  tasks
}

    // MARK: - Extensions

extension UINavigationController {
    // Ask top controller for its status bar style and update accordingly
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UIColor {
    class func lead() -> UIColor {
        return UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
    }
}
