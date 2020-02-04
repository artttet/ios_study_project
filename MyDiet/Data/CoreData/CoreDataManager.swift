import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    func getFetchedResultsController(forEntity entity: Entity, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
        
        switch entity {
        case Entity.AppDay:
            fetchedResultsController = AppDayDataManager.instance.fetchedResultsController(entityName: entity.rawValue, keyForSort: keyForSort)
        case Entity.Recipe:
            fetchedResultsController = RecipeDataManager.instance.fetchedResultsController(entityName: entity.rawValue, keyForSort: keyForSort)
        default: break
        }
        
        return fetchedResultsController!
    }
    
    func saveContext(forEntity: Entity?) {
        
        if let entity = forEntity {
            switch entity {
            case Entity.AppDay:
                AppDayDataManager.instance.saveContext()
            case Entity.Recipe:
                RecipeDataManager.instance.saveContext()
            }
        } else {
            AppDayDataManager.instance.saveContext()
            RecipeDataManager.instance.saveContext()
        }
    }
}
