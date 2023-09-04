//
//  ToDoListItem+CoreDataProperties.swift
//  CoreDataToDoList
//
//  Created by Immanuel Matthews-Feemster on 9/3/23.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var task: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
