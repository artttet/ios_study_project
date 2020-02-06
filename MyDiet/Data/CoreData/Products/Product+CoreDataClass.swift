import CoreData

@objc(Product)
public class Product: NSManagedObject {

    convenience init() {
        let entity = ProductDataManager.instance.entityDescription(forEntityName: "Product")
        let context = ProductDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
