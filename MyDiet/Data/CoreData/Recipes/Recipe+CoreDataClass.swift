import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {

    convenience init() {
        let entity = RecipeModelDataManager.instance.entityDescription(forEntityName: "Recipe")
        let context = RecipeModelDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
