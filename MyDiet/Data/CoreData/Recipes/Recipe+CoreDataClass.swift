import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {

    convenience init() {
        let entity = RecipeDataManager.instance.entityDescription(forEntityName: "Recipe")
        let context = RecipeDataManager.instance.persistentContainer.viewContext
        
        self.init(entity: entity, insertInto: context)
    }
    
}
