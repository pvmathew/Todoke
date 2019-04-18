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
    
    var delegate: TodokeTableViewControllerDelegate?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset.right = 15.0
        timePickerSetup()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(renameTask(sender:)))
        view.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the current theme
        if (UserDefaults.standard.integer(forKey: "theme")) == 1 { // Light Theme
            tableView.backgroundColor = .white
            tableView.separatorColor = .lightGray
        } else { // Dark Theme
            tableView.backgroundColor = .lead()
            tableView.separatorColor = .darkGray
        }
        // Define fetch request for Task objects
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            // Attempts fetch
            print("Tried to fetch once here")
            allTasks = try context.fetch(fetchRequest)
        } catch {
            print("Core Data load failure")
        }
        // When app is being reopened
        
        tableView.reloadData()
    }
    
    // MARK: - New Task Functions
    
    var taskTextField: UITextField!
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Task", message: "What needs doing?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: self.saveTask(sender:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: { (textField) in
            self.taskTextField = textField
            textField.placeholder = "Enter task here"}) //**
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTask(sender: UIAlertAction!) {
        switch sender.title {
        case "Add": // Adding a New Task
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
        case "Save": // Renaming an Existing Task
            allTasks[lastLongPressIndexPath.row].setValue(taskTextField.text, forKey: "title")

            do {
                try context.save()
            } catch {
                print("Core Data save failure")
            }

            tableView.reloadData()
        default:
            print("saveTask failed to save")
        }

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
        }

        if (UserDefaults.standard.integer(forKey: "theme")) == 1 { // Light Theme
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = UIColor.darkGray
            tableView.backgroundColor = .white
            tableView.separatorColor = .lightGray
        } else { // Dark Theme
            cell.backgroundColor = .lead()
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = UIColor.lightGray
            tableView.backgroundColor = .lead()
            tableView.separatorColor = .darkGray
        }
        
        return cell
    }
    
    // MARK: - Remove Task / Done Functions
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(tableView.isEditing)
        
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
    
    @IBAction func leftBarButton(_ sender: UIBarButtonItem) {
        if (tableView.isEditing) { // If in edit-mode
            navigationItem.leftBarButtonItem!.title = "Clear All"
            navigationItem.leftBarButtonItem!.style = .plain
            setEditing(false, animated: true)
            return
        } // Else go on and clear all
        
        // Create and show confirmation window
        let alert = UIAlertController(title: "Clear All", message: "Are you sure?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Do it", style: .default, handler: clearAll(sender:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func clearAll(sender: UIAlertAction) {
        for task in allTasks {
            context.delete(task)
        }
        allTasks.removeAll()
        pickerView.hide()
        tableView.reloadData()
    }
    
    // MARK: - Time Set Functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let date = allTasks[indexPath.row].value(forKey: "time") {
            picker.date = date as! Date
        }
        if (pickerView.isHidden) {
            view.bringSubviewToFront(pickerView)
            pickerView.show()
        }
    }
    
    func timePickerSetup () {
        // Create a datePicker object that points to target "timeChanged"
        picker.datePickerMode = .time
        
        // Set frame to be size that fits width of device
        pickerView = UIView(frame: CGRect(x: 0.0, y: view.frame.height - topbarHeight, width: view.frame.width , height: 240))
        pickerView.backgroundColor = UIColor.white
        pickerView.alpha = 1

        let toolbarArea = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 50))
        pickerView.addSubview(toolbarArea)
        
        let pickerFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width , height: 240)
        picker.frame = pickerFrame
        pickerView.addSubview(picker)
        pickerView.isHidden = true
        view.addSubview(pickerView)
        
        let doneButton = UIButton(frame: CGRect(x: view.frame.width - 70.0 , y: 0.0, width: 60.0, height: 50.0))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.appleBlue(), for: .normal)
        doneButton.addTarget(self, action: #selector(self.timePicked(sender:)), for: .touchUpInside)
        pickerView.addSubview(doneButton)
        
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
    }
    
    @objc func timePicked(sender: UIButton) {
        // Save picker.date to Task object and reload tableView
        let lastIndexPath = self.tableView.indexPathForSelectedRow
        allTasks[lastIndexPath!.row].setValue(picker.date, forKey: "time")
        
        do {
            try context.save()
        } catch {
            print("Core Data save failure")
        }
        
        tableView.reloadData()
        pickerView.hide()
    }
    
    // MARK: - Reorder Task Functions
    
    func activateEditMode() {
        print("Edit mode is being turned on")
        navigationItem.leftBarButtonItem!.title = "Done"
        navigationItem.leftBarButtonItem!.style = .done
        tableView.setEditing(true, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(#function)
        let movedObject = self.allTasks[sourceIndexPath.row]
        print(movedObject.value(forKey: "time") as! Date)
        print(movedObject.value(forKey: "title") as! String)
        allTasks.remove(at: sourceIndexPath.row)
        allTasks.insert(movedObject, at: destinationIndexPath.row)
    }
    
    // MARK: - Rename Task Functions
    
    var lastLongPressIndexPath: IndexPath!
    
    @objc func renameTask(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // Only saving index path if it's not nil
                lastLongPressIndexPath = indexPath
                
                let alert = UIAlertController(title: "Rename Task", message: "How did you mess it up the first time?", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Save", style: .default, handler: self.saveTask(sender:))
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                alert.addTextField(configurationHandler: { (textField) in
                    self.taskTextField = textField
                    textField.text = (self.allTasks[indexPath.row].value(forKey: "title") as! String)}) //**
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // TODO: - More Options feature
    // TODO: - Add a tooltip to let users know they can rename tasks and swipe right for menu
}

    // MARK: - Extensions

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

extension UIView{
    func show(){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func hide(){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
