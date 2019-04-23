//
//  PeopleTableViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/22/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    let fullNames = ["Mehmet Sahin", "Some name", "Some other name"]
    let titles = ["CSC Students", "CIS Prof.", "Advisor"]
    let imageNames = ["1","2","3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UINib(nibName: "CustomPersonCell", bundle: nil), forCellReuseIdentifier: "customPersonCell")
        
        configureTableCells()
    }
    
    func configureTableCells() {
        tableView.rowHeight = 100.0
        tableView.estimatedRowHeight = 125.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fullNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPersonCell", for: indexPath)
        
        cell.textLabel?.text = fullNames[indexPath.row]
        cell.detailTextLabel?.text = titles[indexPath.row]
        
        let img = UIImage(named: imageNames[indexPath.row])!
//        cell.imageView?.layer.cornerRadius = 10.0
//        cell.imageView!.image = img
        cell.imageView!.maskCircle(anyImage: img)

        return cell
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
