//
//  Group.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let reminders = List<Reminder>()
    var person = LinkingObjects(fromType: Person.self, property: "groups")
}
