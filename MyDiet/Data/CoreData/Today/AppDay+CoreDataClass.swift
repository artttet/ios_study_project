import CoreData

@objc(AppDay)
public class AppDay: NSManagedObject {
    
    convenience init() {
        let entity = AppDayDataManager.instance.entityDescription(forEntityName: "AppDay")
        let context = AppDayDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
