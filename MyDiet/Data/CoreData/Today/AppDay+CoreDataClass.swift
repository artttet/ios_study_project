import CoreData

@objc(AppDay)
public class AppDay: NSManagedObject {
    
    convenience init() {
        let entity = AppDayModelDataManager.instance.entityDescription(forEntityName: "AppDay")
        let context = AppDayModelDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
