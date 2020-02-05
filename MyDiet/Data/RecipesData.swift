import UIKit
import CoreData

class RecipesScreenDataManager {
    
    static let instance = RecipesScreenDataManager()
    
    func getRecipeList(withSortKey key: String) -> [Recipe] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: key)
    
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        return fetchedController.fetchedObjects as! [Recipe]
    }
    
    func addRecipe(recipe: Recipe) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: "name")
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        var fetchedObjects = fetchedController.fetchedObjects as! [Recipe]
        
        fetchedObjects.append(recipe)
        
        CoreDataManager.instance.saveContext(forEntity: Entity.Recipe)
    }
    
    func deleteRecipe(at index: Int, withSortKey key: String) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: key)
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let managedObject = fetchedController.object(at: IndexPath(row: index, section: 0)) as! NSManagedObject
        
        CoreDataManager.instance.deleteRecipeObject(object: managedObject)
    }
}
