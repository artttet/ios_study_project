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
        case .Product:
            fetchedResultsController = ProductDataManager.instance.fetchedResultsController(entityName: entity.rawValue, keyForSort: keyForSort)
        }
        
        return fetchedResultsController!
    }
    
    func deleteObject(forEntity entity: Entity, object: NSManagedObject) {
        switch entity {
        case .Recipe: RecipeDataManager.instance.deleteObject(object: object)
        case .Product: ProductDataManager.instance.deleteObject(object: object)
        default: break }
        
    }
    
    func saveContext(forEntity: Entity?) {
        
        if let entity = forEntity {
            switch entity {
            case Entity.AppDay:
                AppDayDataManager.instance.saveContext()
            case Entity.Recipe:
                RecipeDataManager.instance.saveContext()
            case .Product:
                ProductDataManager.instance.saveContext()
            }
        } else {
            AppDayDataManager.instance.saveContext()
            RecipeDataManager.instance.saveContext()
            ProductDataManager.instance.saveContext()
        }
    }
}
