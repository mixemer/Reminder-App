//
//  ReminderTableViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ReminderTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    var reminders: Results<Reminder>?
    
    var selectedGroup: Group? {
        didSet {
            loadReminders()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedGroup?.name
        
        guard let colorHex = selectedGroup?.color else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("No Navigation controller") }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        // searchbar.barTintColor = navBarColor
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let reminder = reminders?[indexPath.row] {
            cell.textLabel?.text = reminder.title
            
            if let color = UIColor(hexString: selectedGroup!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(reminders!.count)) ) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = reminder.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Reminder"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let reminder = reminders?[indexPath.row] {
            do {
                try realm.write {
                    reminder.isDone = !reminder.isDone
                }
            }
            catch {
                print("Error saving done propertey, \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
    }
    
    func loadReminders() {
        reminders = selectedGroup?.reminders.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
