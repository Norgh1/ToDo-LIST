//
//  ToDolistItem+CoreDataProperties.swift
//  ToDo List
//
//  Created by Nor Gh on 26.06.22.
//
//

import Foundation
import CoreData


extension ToDolistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDolistItem> {
        return NSFetchRequest<ToDolistItem>(entityName: "ToDolistItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDolistItem : Identifiable {

}
