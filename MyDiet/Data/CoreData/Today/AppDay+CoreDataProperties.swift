import CoreData

extension AppDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppDay> {
        return NSFetchRequest<AppDay>(entityName: "AppDay")
    }

    @NSManaged public var isSelected: Bool
    @NSManaged public var dayNumber: Int16
    @NSManaged public var dinner: Dish?
    @NSManaged public var breakfast: Dish?
    @NSManaged public var dinner2: Dish?
    @NSManaged public var weekday: Int16

}
