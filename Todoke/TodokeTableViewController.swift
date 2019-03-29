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
    let context = AppDelegate.persistentContainer.viewContext
    
    let picker = UIDatePicker()
    var pickerView = UIView()
    let dateFormatter = DateFormatter()

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.lead()
        timePickerSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        tableView.reloadData()
        
    }
    
    // MARK: - Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = allTasks[indexPath.row].value(forKey: "title") as? String
        
        // If time exists, set it to be the detail text label
        if let dateFromObject = allTasks[indexPath.row].value(forKey: "time") as? Date {
            let dateString = dateFormatter.string(from: dateFromObject)
            cell.detailTextLabel?.text = dateString
        } else {
            print("there was no date found")
        }

        cell.backgroundColor = UIColor.lead()
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.accessoryView?.tintColor = UIColor.darkGray
        return cell
    }
    
    // MARK: - Remove Task Functions
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
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
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        for task in allTasks {
            context.delete(task)
        }
        allTasks.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Time Set Functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addSubview(pickerView)
    }
    
    func timePickerSetup () {
        // Create a datePicker object that points to target "timeChanged"
        picker.datePickerMode = .time
        
        // Set frame to be size that fits width of device
        pickerView = UIView(frame: CGRect(x: 0.0, y: view.frame.height - topbarHeight - 280, width: view.frame.width , height: 280))
        pickerView.backgroundColor = UIColor.white
        pickerView.alpha = 0.7

        let toolbarArea = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 50))
        pickerView.addSubview(toolbarArea)
        
        let doneButton = UIButton(frame: CGRect(x: view.frame.width - 70.0 , y: 0.0, width: 60.0, height: 50.0))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.appleBlue(), for: .normal)
        doneButton.addTarget(self, action: #selector(self.timePickingFinished(sender:)), for: .touchUpInside)
        pickerView.addSubview(doneButton)
        
        let pickerFrame = CGRect(x: 0.0, y: 40.0, width: view.frame.width , height: 240)
        picker.frame = pickerFrame
        pickerView.addSubview(picker)
        
        dateFormatter.dateFormat = "HH:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
    }
    
    @objc func timePickingFinished(sender: UIButton) {
        // TODO: - Save picker.date to Task object and reload tableView
        
        
        self.pickerView.removeFromSuperview()
    }
    
    // TODO: - Multiple pages/sections for different types of tasks
    // TODO: - Settings menu with option to change theme
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
    class func appleBlue() -> UIColor {
        return UIColor(red: 14.0/255, green: 144.0/255, blue: 254.0/255, alpha: 1.0)
    }
}

extension UIViewController {
    // Grabs height of status bar + navigation bar
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

