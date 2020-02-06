//
//  Product+CoreDataProperties.swift
//  MyDiet
//
//  Created by Artas on 06/02/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?
    @NSManaged public var isHave: Bool
    @NSManaged public var addDate: Date
}
