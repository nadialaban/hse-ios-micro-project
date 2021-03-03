//
//  Task+CoreDataProperties.swift
//  TaskTracker
//
//  Created by Nadia on 01.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
            return NSFetchRequest<Task>(entityName: "Task")
        }

    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var status: String
    @NSManaged public var note: String

}

extension Task : Identifiable {

}
