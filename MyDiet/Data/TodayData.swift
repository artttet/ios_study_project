import UIKit

class TodayScreenDataManager {
    
    static let instance = TodayScreenDataManager()
    
    func getAppDayList(withSortKey sortKey: String) -> [AppDay]{
        let fetchedResultsController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.AppDay, keyForSort: sortKey)
        
        do {
            try fetchedResultsController.performFetch()
        } catch { print(error) }
        
        return fetchedResultsController.fetchedObjects as! [AppDay]
    }
    
    func changeIsEaten(in index: Int, withTag tag: Int, state: Bool) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.AppDay, keyForSort: "dayNumber")
        
        do {
            try fetchedController.performFetch()
        }catch {
            print(error)
        }
        
        let appDay = fetchedController.object(at: IndexPath(row: index, section: 0)) as! AppDay
        
        switch tag {
        case 0: appDay.breakfast!.isEaten = state
        case 1: appDay.dinner!.isEaten = state
        case 2: appDay.dinner2!.isEaten = state
        default: break
        }
        
        CoreDataManager.instance.saveContext(forEntity: Entity.AppDay)
    }
    
}

extension TodayScreenDataManager {
    
    func dishName(fromWeekday weekday: Int, dishCategory: Int) -> String {
        var name: String = ""
        switch weekday {
        case 2, 3, 4:
            switch dishCategory {
            case 0: name = "Овсянка с ягодой"
            case 1: name = "Гречка по-купечески"
            case 2: name = "Салат с чечевицой"
            default: break
            }
        case 5, 6:
            switch dishCategory {
            case 0: name = "Варенные яйца"
            case 1: name = "Грибной крем-суп"
            case 2: name = "Салат со свеклой и шпинатом"
            default: break
            }

        case 7, 1:
            switch dishCategory {
            case 0: name = "Салат с творогом"
            case 1: name = "Салат с шампиньонами и фасолью"
            case 2: name = "Салат с рукколой и грушей"
            default: break
            }
        default: break
        }

        return name
    }
    
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
            
            let breakfast = Dish()
            breakfast.name = dishName(fromWeekday: weekday, dishCategory: 0)
            appDay.breakfast = breakfast
            
            let dinner = Dish()
            dinner.name = dishName(fromWeekday: weekday, dishCategory: 1)
            appDay.dinner = dinner
            
            let dinner2 = Dish()
            dinner2.name = dishName(fromWeekday: weekday, dishCategory: 2)
            appDay.dinner2 = dinner2
            
            CoreDataManager.instance.saveContext(forEntity: Entity.AppDay)
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
            monthName = "Январь"
        case 2:
            monthName = "Февраль"
        case 3:
            monthName = "Март"
        case 4:
            monthName = "Апрель"
        case 5:
            monthName = "Май"
        case 6:
            monthName = "Июнь"
        case 7:
            monthName = "Июль"
        case 8:
            monthName = "Август"
        case 9:
            monthName = "Сентябрь"
        case 10:
            monthName = "Октябрь"
        case 11:
            monthName = "Ноябрь"
        case 12:
            monthName = "Декабрь"
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
            
            switch weekdayNumber {
            case 1: weekdayName = Weekdays.Sunday.description(isShort: isShort)
            case 2: weekdayName = Weekdays.Monday.description(isShort: isShort)
            case 3: weekdayName = Weekdays.Tuesday.description(isShort: isShort)
            case 4: weekdayName = Weekdays.Wednesday.description(isShort: isShort)
            case 5: weekdayName = Weekdays.Thursday.description(isShort: isShort)
            case 6: weekdayName = Weekdays.Friday.description(isShort: isShort)
            case 7: weekdayName = Weekdays.Saturday.description(isShort: isShort)
            default: break
            }
        }
        
        return (weekdayName!, weekdayNumber!)
    }
}
