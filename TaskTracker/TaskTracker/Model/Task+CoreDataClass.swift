//
//  Task+CoreDataClass.swift
//  TaskTracker
//
//  Created by Nadia on 01.03.2021.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

    func configure(title: String, date: Date, comment: String) {
        self.title = title
        self.date = date
        self.note = comment
    }

}
