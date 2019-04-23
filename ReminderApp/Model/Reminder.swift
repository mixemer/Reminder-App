//
//  Reminder.swift
//  ReminderApp
//
//  Created by Mehmet Sahin on 4/23/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import Foundation
import RealmSwift

class Reminder: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
//    @objc dynamic var forPerson: Person?
    var parentGroup = LinkingObjects(fromType: Group.self, property: "reminders")
}
