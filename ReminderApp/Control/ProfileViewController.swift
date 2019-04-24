//
//  ProfileViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    let formatter = DateFormatter()
    let realm = try! Realm()
    var person: Person?
    var imgNum: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        // Do any additional setup after loading the view.
    }
    
    
    func loadInfo() {
        formatter.dateFormat = "MM/dd/yyyy"
        if let p = person {
            imgView.maskCircle(anyImage: UIImage(named: imgNum!)!)
            fullNameLabel.text = "\(p.firstName) \(p.lastName)"
            groupLabel.text = p.title ?? ""
            birthdayLabel.text = "Birthday: \(formatter.string(from: p.birthday ?? formatter.date(from: "01/01/2000")!))"
            emailLabel.text = "Email: \(p.emailAdress ?? "")"
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let p = person {
            do {
                try realm.write {
                    self.realm.delete(p)
                }
            }
            catch {
                print("Error: cannot delete person \(error)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
