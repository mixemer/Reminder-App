//
//  PeopleTableViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/22/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import RealmSwift

class PeopleTableViewController: UITableViewController {
    
    let fullNames = ["Mehmet Sahin", "Some name", "Some other name"]
    let titles = ["CSC Students", "CIS Prof.", "Advisor"]
    let imageNames = ["1","2","3", "4", "5", "6"]
    
    let realm = try! Realm()
    
    var people: Results<Person>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableCells()
        loadPeope()
    }
    
    func configureTableCells() {
        tableView.rowHeight = 100.0
        tableView.estimatedRowHeight = 125.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPersonCell", for: indexPath)
        
        if let person = people?[indexPath.row] {
            cell.textLabel?.text = "\(String(describing: person.firstName)) \(String(describing: person.lastName))"
            cell.detailTextLabel?.text = person.title ?? ""
            
            let img = UIImage(named: imageNames[indexPath.row])!
            //        cell.imageView?.layer.cornerRadius = 10.0
            //        cell.imageView!.image = img
            cell.imageView!.maskCircle(anyImage: img)
        } else {
            cell.textLabel?.text = "No People yet"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToPerson", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPerson" {
            let destinVC = segue.destination as! ProfileViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                destinVC.person = people?[indexPath.row]
                destinVC.imgNum = imageNames[indexPath.row]
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    
    func loadPeope() {
        people = realm.objects(Person.self)
        
        self.tableView.reloadData()
    }
    
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
