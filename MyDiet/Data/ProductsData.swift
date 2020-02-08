import UIKit
import CoreData

class ProductsScreenDataManager {
    
    static let instance = ProductsScreenDataManager()
    
    func getProductList(withSortKey key: String) -> [Product] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Product, keyForSort: key)
    
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        return fetchedController.fetchedObjects as! [Product]
    }
    
    func addProduct(product: Product) {
        var fetchedObjects = getProductList(withSortKey: "addDate")
        
        fetchedObjects.append(product)
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
    
    func deleteProduct(at index: Int, withSortKey key: String) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Product, keyForSort: key)
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let managedObject = fetchedController.object(at: IndexPath(row: index, section: 0)) as! NSManagedObject
        
        CoreDataManager.instance.deleteObject(forEntity: .Product, object: managedObject)
    }
    
    func changeName(in index: Int, to name: String) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Product, keyForSort: "addDate")
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let product = fetchedController.object(at: IndexPath(row: index, section: 0)) as! Product
        product.name = name
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
    
    func changeIsHave(in index: Int, to state: Bool) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Product, keyForSort: "addDate")
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let product = fetchedController.object(at: IndexPath(row: index, section: 0)) as! Product
        
        product.isHave = state
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
}
