import UIKit
import CoreData

class ProductsScreenDataManager {
    
    static let instance = ProductsScreenDataManager()
    
    func getProductList(withSortKey key: String) -> [Product] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Product, keyForSort: key)
    
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        return fetchedController.fetchedObjects as! [Product]
    }
    
    func addProduct(product: Product) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Product, keyForSort: "addDate")
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        var fetchedObjects = fetchedController.fetchedObjects as! [Product]
        
        fetchedObjects.append(product)
        
        CoreDataManager.instance.saveContext(forEntity: Entity.Product)
    }
    
    func deleteProdutc(at index: Int, withSortKey key: String) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Product, keyForSort: key)
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let managedObject = fetchedController.object(at: IndexPath(row: index, section: 0)) as! NSManagedObject
        
        CoreDataManager.instance.deleteObject(forEntity: Entity.Product, object: managedObject)
    }
    
    func changeIsHave(in index: Int, to state: Bool) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Product, keyForSort: "addDate")
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let product = fetchedController.object(at: IndexPath(row: index, section: 0)) as! Product
        
        product.isHave = state
        
        CoreDataManager.instance.saveContext(forEntity: Entity.Product)
    }
}
