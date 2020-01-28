//
//  AppDay+CoreDataProperties.swift
//  MyDiet
//
//  Created by Artas on 28/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//
//

import Foundation
import CoreData


extension AppDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppDay> {
        return NSFetchRequest<AppDay>(entityName: "AppDay")
    }

    @NSManaged public var isSelected: Bool
    @NSManaged public var dayNumber: Int16
    @NSManaged public var dinner: Dish?
    @NSManaged public var breakfast: Dish?
    @NSManaged public var dinner2: Dish?

}
