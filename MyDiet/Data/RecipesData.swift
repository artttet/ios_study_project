import UIKit
import CoreData

class RecipesScreenDataManager {
    
    static let instance = RecipesScreenDataManager()
    
    func getRecipeList(withSortKey sortKey: String) -> [Recipe] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: sortKey)
    
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
}
