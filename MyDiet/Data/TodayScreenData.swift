import UIKit
//import CoreData

class TodayScreenDataManager {
    
    static let instance = TodayScreenDataManager()
    
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
            
            let weekday = appCalendar.day(fromDayNumber: dayNumber, isShort: false).weekdayNumber
            
            let breakfast = Dish()
            breakfast.name = dishName(fromWeekday: weekday, dishCategory: 0)
            appDay.breakfast = breakfast
            
            let dinner = Dish()
            dinner.name = dishName(fromWeekday: weekday, dishCategory: 1)
            appDay.dinner = dinner
            
            let dinner2 = Dish()
            dinner2.name = dishName(fromWeekday: weekday, dishCategory: 2)
            appDay.dinner2 = dinner2
            
            CoreDataManager.instance.saveContext()
        }
    }
    
    func changeIsEaten(in index: Int, withTag tag: Int, state: Bool) {
        let fetched = CoreDataManager.instance.fetchedResultsController(entityName: "AppDay", keyForSort: "dayNumber")
        
        do {
            try fetched.performFetch()
        }catch {
            print(error)
        }
        
        let appDay = fetched.object(at: IndexPath(row: index, section: 0)) as! AppDay
        
        switch tag {
        case 0:
            appDay.breakfast!.isEaten = state
        case 1:
            appDay.dinner!.isEaten = state
        case 2:
            appDay.dinner2!.isEaten = state
        default:
            break
        }
        
        CoreDataManager.instance.saveContext()
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
        
        switch month {
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

        return (month, monthName)
    }
    
    func day(fromDayNumber dayNumber: Int, isShort: Bool) -> (dayName: String, weekdayNumber: Int) {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: dayNumber)
        var dayName: String = ""
        var weekday: Int = -1
        
        if let date = calendar.date(from: dateComponents) {
            weekday = calendar.component(.weekday, from: date)
            
            switch weekday {
            case 1:
                if isShort{
                    dayName = "Вс"
                }else {
                    dayName = "Воскресенье"
                }
            case 2:
            if isShort{
                dayName = "Пн"
            }else {
                dayName = "Понедельник"
            }
            case 3:
                if isShort{
                    dayName = "Вт"
                }else {
                    dayName = "Вторник"
                }
            case 4:
                if isShort{
                    dayName = "Ср"
                }else {
                    dayName = "Среда"
                }
            case 5:
                if isShort{
                    dayName = "Чт"
                }else {
                    dayName = "Четверг"
                }
            case 6:
                if isShort{
                    dayName = "Пт"
                }else {
                    dayName = "Пятница"
                }
            case 7:
                if isShort{
                    dayName = "Сб"
                }else {
                    dayName = "Суббота"
                }
            default:
                break
            }
        }
        
        return (dayName, weekday)
    }
}
