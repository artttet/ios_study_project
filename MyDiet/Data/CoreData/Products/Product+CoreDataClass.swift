import CoreData

@objc(Product)
public class Product: NSManagedObject {

    convenience init() {
        let entity = ProductModelDataManager.instance.entityDescription(forEntityName: "Product")
        let context = ProductModelDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
