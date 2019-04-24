//
//  GroupsTableViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class GroupsTableViewController: SwipeTableViewController {
    
   let realm = try! Realm()
    
    var groups: Results<Group>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroups()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let group = groups?[indexPath.row] {
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = "0"
            
            guard let groupColor = UIColor(hexString: group.color) else { fatalError() }
            
            cell.backgroundColor = groupColor
            cell.textLabel?.textColor = ContrastColorOf(groupColor, returnFlat: true)
            cell.detailTextLabel?.textColor = ContrastColorOf(groupColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Group yet"
        }
        
        return cell
    }
    
    
    // MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToReminder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinVC = segue.destination as! ReminderTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinVC.selectedGroup = groups?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Group", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            let newGroup = Group()
            newGroup.name = textField.text!
            newGroup.color = UIColor.randomFlat.hexValue()
            
            self.saveGroup(newGroup)
        }
        
        alert.addTextField {
            (alertTextField) in
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    func saveGroup(_ group: Group) {
        do {
            try realm.write {
                realm.add(group)
            }
        }
        catch {
            print("Error: cannot save group \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadGroups() {
        groups = realm.objects(Group.self)
        
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let groupForDeletion = self.groups?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(groupForDeletion)
                }
            }
            catch {
                print("Error: cannot delete group \(error)")
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
}
