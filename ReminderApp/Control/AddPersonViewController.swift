//
//  AddPersonViewController.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import RealmSwift

class AddPersonViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var groupField: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // already added the delegates
        
        // Listen to notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        addDatePickerToBirthdayField()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addDatePickerToBirthdayField() {
        datePicker.datePickerMode = .date
        
        // ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cance", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        birthdayField.inputAccessoryView = toolbar
        birthdayField.inputView = datePicker
    }
    
    @objc func doneDatePicker() {
        
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            fatalError()
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegare Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let newPerson = Person()
        newPerson.firstName = firstName.text ?? ""
        newPerson.lastName = lastName.text ?? ""
//        let group = Group()
//        group.name = groupField.text ?? ""
//        group.color = "FFFFFF"
//        newPerson.groups.append(group)
        // add phone number
        newPerson.birthday = formatter.date(from: birthdayField.text ?? "01/01/2000")
        newPerson.notes = notesField.text ?? ""

        savePerson(newPerson)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func savePerson(_ person: Person) {
        do {
            try realm.write {
                realm.add(person)
            }
        }
        catch {
            print("Error: cannot save person \(error)")
        }
    }
}
