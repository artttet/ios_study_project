import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    func getFetchedResultsController(forEntity entity: CoreDataManager.Entity, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
        
        switch entity {
        case Entity.AppDay:
            fetchedResultsController = AppDayModelDataManager.instance.fetchedResultsController(entity: entity, keyForSort: keyForSort)
        case Entity.Recipe:
            fetchedResultsController = RecipeModelDataManager.instance.fetchedResultsController(entity: entity, keyForSort: keyForSort)
        case .Product:
            fetchedResultsController = ProductModelDataManager.instance.fetchedResultsController(entity: entity, keyForSort: keyForSort)
        }
        
        return fetchedResultsController!
    }
    
    func getObject(forEntity entity: CoreDataManager.Entity, at index: Int, withKeyForSort sortKey: String) -> Any {
        let fetchedController = getFetchedResultsController(forEntity: entity, keyForSort: sortKey)
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        return fetchedController.object(at: IndexPath(row: index, section: 0))
    }
    
    func deleteObject(forEntity entity: CoreDataManager.Entity, object: NSManagedObject) {
        switch entity {
        case .Recipe: RecipeModelDataManager.instance.deleteObject(object: object)
        case .Product: ProductModelDataManager.instance.deleteObject(object: object)
        default: break }
    }
    
    func saveContext(forEntity: CoreDataManager.Entity?) {
        if let entity = forEntity {
            switch entity {
            case Entity.AppDay:
                AppDayModelDataManager.instance.saveContext()
            case Entity.Recipe:
                RecipeModelDataManager.instance.saveContext()
            case .Product:
                ProductModelDataManager.instance.saveContext()
            }
        } else {
            AppDayModelDataManager.instance.saveContext()
            RecipeModelDataManager.instance.saveContext()
            ProductModelDataManager.instance.saveContext()
        }
    }
}

// MARK: - Entity enum
extension CoreDataManager {
    enum Entity: String {
        case AppDay
        case Recipe
        case Product
        func modelName() -> String {
            switch self {
            case .AppDay:
                return "AppDayModel"
            case .Recipe:
                return "RecipeModel"
            case .Product:
                return "ProductModel"
            }
        }
    }
}
