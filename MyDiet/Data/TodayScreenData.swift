import UIKit

class TodayScreenDataManager {
    
    static let instance = TodayScreenDataManager()
    
    static let WeekdayKeys = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    func createAppDays() {
        let appCalendar = AppCalendar.instance
        
        for dayNumber in 1...appCalendar.daysInMonth {
            let appDay = AppDay()
            
            appDay.dayNumber = Int16(dayNumber)
            if dayNumber == appCalendar.day {
                appDay.isSelected = true
            } else {
                appDay.isSelected = false
            }
            
            let weekday = appCalendar.getWeekday(fromDayNumber: dayNumber, isShort: false).number
            appDay.weekday = Int16(weekday)
            
            let breakfast = Dish()
            breakfast.name = dishName(fromWeekday: weekday, dishCategory: 0)
            appDay.breakfast = breakfast
            
            let dinner = Dish()
            dinner.name = dishName(fromWeekday: weekday, dishCategory: 1)
            appDay.dinner = dinner
            
            let dinner2 = Dish()
            dinner2.name = dishName(fromWeekday: weekday, dishCategory: 2)
            appDay.dinner2 = dinner2
            
            CoreDataManager.instance.saveContext(forEntity: .AppDay)
        }
    }
    
    func getAppDayList(withSortKey sortKey: String) -> [AppDay]{
        let fetchedResultsController = CoreDataManager.instance.getFetchedResultsController(forEntity: .AppDay, keyForSort: sortKey)
        
        do {
            try fetchedResultsController.performFetch()
        } catch { print(error) }
        
        return fetchedResultsController.fetchedObjects as! [AppDay]
    }
    
    func changeIsEaten(at index: Int, withTag tag: Int, state: Bool) {
        let appDay = CoreDataManager.instance.getObject(forEntity: .AppDay, at: index, withKeyForSort: "dayNumber") as! AppDay
        
        switch tag {
        case 0: appDay.breakfast!.isEaten = state
        case 1: appDay.dinner!.isEaten = state
        case 2: appDay.dinner2!.isEaten = state
        default: break
        }
        
        CoreDataManager.instance.saveContext(forEntity: .AppDay)
    }
    
    func changeIsSelected(at index: Int, state: Bool) {
        let appDay = CoreDataManager.instance.getObject(forEntity: .AppDay, at: index, withKeyForSort: "dayNumber") as! AppDay
        
        appDay.isSelected = state
        
        CoreDataManager.instance.saveContext(forEntity: .AppDay)
    }
    
}

// MARK: - Dishes

extension TodayScreenDataManager {
    
    func createStartDishes() {
        let names = [
            "Овсянка с ягодами",
            "Гречка по-купечески",
            "Салат с чечевицой",
            "Варенные яйца",
            "Грибной крем-суп",
            "Салат со свеклой и шпинатом",
            "Салат с творогом",
            "Салат с шампиньонами и фасолью",
            "Салат с рукколой и грушей",
        ]
        
        UserDefaults.standard.set([names[6], names[7], names[8]], forKey: TodayScreenDataManager.WeekdayKeys[0])
        UserDefaults.standard.set([names[0], names[1], names[2]], forKey: TodayScreenDataManager.WeekdayKeys[1])
        UserDefaults.standard.set([names[0], names[1], names[2]], forKey: TodayScreenDataManager.WeekdayKeys[2])
        UserDefaults.standard.set([names[0], names[1], names[2]], forKey: TodayScreenDataManager.WeekdayKeys[3])
        UserDefaults.standard.set([names[3], names[4], names[5]], forKey: TodayScreenDataManager.WeekdayKeys[4])
        UserDefaults.standard.set([names[3], names[4], names[5]], forKey: TodayScreenDataManager.WeekdayKeys[5])
        UserDefaults.standard.set([names[6], names[7], names[8]], forKey: TodayScreenDataManager.WeekdayKeys[6])
    }
    
    func updateDishes() {
        let appDayList = getAppDayList(withSortKey: "dayNumber")
        
        appDayList.forEach({ appDay in
            let breakfast = appDay.breakfast
            breakfast!.name = dishName(fromWeekday: Int(appDay.weekday), dishCategory: 0)
            appDay.breakfast = breakfast
            
            let dinner = appDay.dinner
            dinner!.name = dishName(fromWeekday: Int(appDay.weekday), dishCategory: 1)
            appDay.dinner = dinner
            
            let dinner2 = appDay.dinner2
            dinner2!.name = dishName(fromWeekday: Int(appDay.weekday), dishCategory: 2)
            appDay.dinner2 = dinner2
        })
        
        CoreDataManager.instance.saveContext(forEntity: .AppDay)
    }
    
    func changeDish(on newDish: String, inCategory category: Int, forKey weekdayKey: String) {
        var dishes = UserDefaults.standard.array(forKey: weekdayKey)
        dishes![category] = newDish
        UserDefaults.standard.set(dishes, forKey: weekdayKey)
    }
    
    func dishName(fromWeekday weekday: Int, dishCategory: Int) -> String {
        let names = UserDefaults.standard.array(forKey: TodayScreenDataManager.WeekdayKeys[weekday-1]) as! [String]

        return names[dishCategory]
    }
}

// MARK: - Weekdays

extension TodayScreenDataManager {
    enum Weekdays{
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        func description(isShort: Bool) -> String {
            switch self {
            case .monday:
                if isShort { return NSLocalizedString("Mon", comment: "") }
                else { return NSLocalizedString("Monday", comment: "") }
            case .tuesday:
                if isShort { return NSLocalizedString("Tue", comment: "") }
                else { return NSLocalizedString("Tuesday", comment: "") }
            case .wednesday:
                if isShort { return NSLocalizedString("Wed", comment: "") }
                else { return NSLocalizedString("Wednesday", comment: "") }
            case .thursday:
                if isShort {return NSLocalizedString("Thu", comment: "") }
                else { return NSLocalizedString("Thursday", comment: "") }
            case .friday:
                if isShort { return NSLocalizedString("Fri", comment: "") }
                else { return NSLocalizedString("Friday", comment: "") }
            case .saturday:
                if isShort { return NSLocalizedString("Sat", comment: "") }
                else { return NSLocalizedString("Saturday", comment: "") }
            case .sunday:
                if isShort { return NSLocalizedString("Sun", comment: "") }
                else { return NSLocalizedString("Sunday", comment: "") }
            }
        }
    }
}

class AppCalendar {
    
    static let instance = AppCalendar()
    
    let calendar: Calendar
    
    let year: Int
    
    let month: Int
    
    let day: Int
    
    var daysInMonth: Int
    
    init() {
        let date = Date()
        
        calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        daysInMonth = 30
        
        if let dateForCount = calendar.date(from: DateComponents(year: year, month: month)) {
            if let range = calendar.range(of: .day, in: . month, for: dateForCount) {
                daysInMonth = range.count
            }
        }
    }
    
    func getMonth() -> (number: Int, name: String) {
        var monthName: String = ""
        
        switch self.month {
        case 1:
            monthName = NSLocalizedString("January", comment: "")
        case 2:
            monthName = NSLocalizedString("February", comment: "")
        case 3:
            monthName = NSLocalizedString("March", comment: "")
        case 4:
            monthName = NSLocalizedString("April", comment: "")
        case 5:
            monthName = NSLocalizedString("May", comment: "")
        case 6:
            monthName = NSLocalizedString("June", comment: "")
        case 7:
            monthName = NSLocalizedString("July", comment: "")
        case 8:
            monthName = NSLocalizedString("August", comment: "")
        case 9:
            monthName = NSLocalizedString("September", comment: "")
        case 10:
            monthName = NSLocalizedString("October", comment: "")
        case 11:
            monthName = NSLocalizedString("November", comment: "")
        case 12:
            monthName = NSLocalizedString("December", comment: "")
        default:
            break
        }

        return (self.month, monthName)
    }
    
    func getWeekday(fromDayNumber dayNumber: Int, isShort: Bool) -> (name: String, number: Int) {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: dayNumber)
        var weekdayName: String?
        var weekdayNumber: Int?
        
        if let date = calendar.date(from: dateComponents) {
            weekdayNumber = calendar.component(.weekday, from: date)
            
            var weekday: TodayScreenDataManager.Weekdays!
            
            switch weekdayNumber {
            case 1: weekday = .sunday
            case 2: weekday = .monday
            case 3: weekday = .tuesday
            case 4: weekday = .wednesday
            case 5: weekday = .thursday
            case 6: weekday = .friday
            case 7: weekday = .saturday
            default: break
            }
            
            weekdayName = weekday.description(isShort: isShort)
        }
        
        return (weekdayName!, weekdayNumber!)
    }
}
