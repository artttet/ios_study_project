import CoreData

class RecipeModelDataManager {
    
    static let instance = RecipeModelDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.Entity.Recipe.modelName())
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func entityDescription(forEntityName name: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: name, in: persistentContainer.viewContext)!
    }
    
    func fetchedResultsController(entity: CoreDataManager.Entity, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func deleteObject(object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
        saveContext()
    }

    func saveContext () {
      let context = persistentContainer.viewContext
        
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
    }
}
