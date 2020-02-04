import CoreData

extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var category: String?
    @NSManaged public var ingredients: Data?
    @NSManaged public var name: String?
    @NSManaged public var steps: Data?

}
