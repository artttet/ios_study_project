import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    //let managedObjectContext = instance.persistentContainer.viewContext

    private init() {}
    
    func entityDescription(forEntityName name: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: name, in: persistentContainer.viewContext)!
    }
    
    func fetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "AppDayModel")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
    }()

    // MARK: - Core Data Saving support

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
