//
//  Dish+CoreDataClass.swift
//  MyDiet
//
//  Created by Artas on 28/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dish)
public class Dish: NSManagedObject {

    convenience init() {
        let entity = CoreDataManager.instance.entityDescription(forEntityName: "Dish")
        let context = CoreDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
