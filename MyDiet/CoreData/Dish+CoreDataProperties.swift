//
//  Dish+CoreDataProperties.swift
//  MyDiet
//
//  Created by Artas on 28/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var isEaten: Bool
    @NSManaged public var name: String?

}
