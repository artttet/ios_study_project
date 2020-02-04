import CoreData

@objc(Dish)
public class Dish: NSManagedObject {

    convenience init() {
        let entity = AppDayDataManager.instance.entityDescription(forEntityName: "Dish")
        let context = AppDayDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
