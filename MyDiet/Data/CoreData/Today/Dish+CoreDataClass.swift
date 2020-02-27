import CoreData

@objc(Dish)
public class Dish: NSManagedObject {

    convenience init() {
        let entity = AppDayModelDataManager.instance.entityDescription(forEntityName: "Dish")
        let context = AppDayModelDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
