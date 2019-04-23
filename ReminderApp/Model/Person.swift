//
//  Person.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/22/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var title: String?
    @objc dynamic var birthday: Date?
    @objc dynamic var emailAdress: String?
    @objc dynamic var favoriateColor: String?
    @objc dynamic var notes: String?
    
    let groups = List<Group>()
}
