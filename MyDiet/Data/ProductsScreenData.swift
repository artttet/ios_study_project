import UIKit
import CoreData

class ProductsScreenDataManager {
    
    static let instance = ProductsScreenDataManager()
    
    func getProductList(withSortKey key: String) -> [Product] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Product, keyForSort: key)
    
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let fetchedObjects = fetchedController.fetchedObjects as! [Product]
        
        return fetchedController.fetchedObjects as! [Product]
    }
    
    func addProduct(product: Product) {
        var fetchedObjects = getProductList(withSortKey: "addDate")
        
        fetchedObjects.append(product)
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
    
    func deleteProduct(at index: Int, withSortKey key: String) {
        let managedObject = CoreDataManager.instance.getObject(forEntity: .Product, at: index, withKeyForSort: key) as! NSManagedObject
        CoreDataManager.instance.deleteObject(forEntity: .Product, object: managedObject)
    }
    
    func changeName(in index: Int, to name: String) {
        let product = CoreDataManager.instance.getObject(forEntity: .Product, at: index, withKeyForSort: "addDate") as! Product
        product.name = name
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
    
    func changeIsHave(in index: Int, to state: Bool) {
        let product = CoreDataManager.instance.getObject(forEntity: .Product, at: index, withKeyForSort: "addDate") as! Product
        product.isHave = state
        
        CoreDataManager.instance.saveContext(forEntity: .Product)
    }
}
