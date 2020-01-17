import UIKit

struct CalendarDay {
    var dayNumber: Int
    var dayName: String
    var isSelected: Bool
}

struct CardDay {
    var weekdayName: String
    var breakfast: Dish
    var dinner: Dish
    var dinner2: Dish
}

struct Dish {
    var dishName: String
    var isEaten: Bool = false
}

class TodayScreenData {
    private let appCalendar: AppCalendar = AppCalendar()
    var calendarDaysList: [CalendarDay]
    var cardDaysList: [CardDay] = []
    var currentDay: Int
    
    init(){
        let daysList = appCalendar.createDaysList()
        calendarDaysList = daysList.clendarDaysList
        currentDay = daysList.currentDay
        createCardDaysList(daysList.dayNamesList)
    }
    
    @objc func dishMarkOn(notifi: Notification) {
        if let dayIndex = notifi.userInfo?["dayIndex"] as? Int{
            if let dishIndex = notifi.userInfo?["dishIndex"] as? Int{
                switch dishIndex {
                case 0: cardDaysList[dayIndex].breakfast.isEaten = true
                case 1: cardDaysList[dayIndex].dinner.isEaten = true
                case 2: cardDaysList[dayIndex].dinner.isEaten = true
                default:
                    break
                }
            }
        }
    }
    
    @objc func dishMarkOff(notifi: Notification) {
        if let dayIndex = notifi.userInfo?["dayIndex"] as? Int{
            if let dishIndex = notifi.userInfo?["dishIndex"] as? Int{
                switch dishIndex {
                case 0: cardDaysList[dayIndex].breakfast.isEaten = false
                case 1: cardDaysList[dayIndex].dinner.isEaten = false
                case 2: cardDaysList[dayIndex].dinner.isEaten = false
                default:
                    break
                }
            }
        }
    }
    
    func getMonth() -> (int: Int, str: String) {
        let month = appCalendar.month
        return (month, appCalendar.getMonthFromNumber(monthNumber: month))
    }
    
    func dishNameFromWeekday(dayName: String, dishCategory: Int) -> String {
        var name: String = ""
        switch dayName {
        case Weekdays.Monday.description(isShort: false), Weekdays.Tuesday.description(isShort: false), Weekdays.Wednesday.description(isShort: false):
            switch dishCategory {
            case 0: name = "Овсянка с ягодой"
            case 1: name = "Гречка по-купечески"
            case 2: name = "Салат с чечевицой"
            default: break
            }
        case Weekdays.Thursday.description(isShort: false), Weekdays.Friday.description(isShort: false):
            switch dishCategory {
            case 0: name = "Варенные яйца"
            case 1: name = "Грибной крем-суп"
            case 2: name = "Салат со свеклой и шпинатом"
            default: break
            }
        
        case Weekdays.Saturday.description(isShort: false), Weekdays.Sunday.description(isShort: false):
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
    
    func createCardDaysList(_ dayNamesList: [String]) {
        
        for dayName in dayNamesList {
            let breakfast = Dish(dishName: dishNameFromWeekday(dayName: dayName, dishCategory: 0))
            let dinner = Dish(dishName: dishNameFromWeekday(dayName: dayName, dishCategory: 1))
            let dinner2 = Dish(dishName: dishNameFromWeekday(dayName: dayName, dishCategory: 2))
            
            cardDaysList.append(CardDay(weekdayName: dayName, breakfast: breakfast, dinner: dinner, dinner2: dinner2))
        }
    }
}

class AppCalendar {
    var year: Int
    var month: Int
    var day: Int
    var daysInMonth: Int
    let calendar: Calendar
    
    init(){
        let date = Date()
        
        calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        
        let dateForCount = calendar.date(from: DateComponents(year: year, month: month))!
        daysInMonth = calendar.getDaysInMonth(date: dateForCount)
    }
    
    func getMonthFromNumber(monthNumber: Int) -> String{
        var month: String = ""
        
        switch monthNumber {
        case 1:
            month = "Январь"
        case 2:
            month = "Февраль"
        case 3:
            month = "Март"
        case 4:
            month = "Апрель"
        case 5:
            month = "Май"
        case 6:
            month = "Июнь"
        case 7:
            month = "Июль"
        case 8:
            month = "Август"
        case 9:
            month = "Сентябрь"
        case 10:
            month = "Октябрь"
        case 11:
            month = "Ноябрь"
        case 12:
            month = "Декабрь"
        default:
            break
        }
        
        return month
    }
    
    func getWeekdayFromDay(dayNumber: Int, isShort: Bool) -> String {
        let dateComponents = DateComponents(year: year, month: month, day: dayNumber)
        let date = calendar.date(from: dateComponents)!
        let weekday = calendar.component(.weekday, from: date)
        
        var strWeekday: String = ""
        
        switch weekday {
        case 1:
            strWeekday = Weekdays.Sunday.description(isShort: isShort)
        case 2:
            strWeekday = Weekdays.Monday.description(isShort: isShort)
        case 3:
           strWeekday = Weekdays.Tuesday.description(isShort: isShort)
        case 4:
            strWeekday = Weekdays.Wednesday.description(isShort: isShort)
        case 5:
            strWeekday = Weekdays.Thursday.description(isShort: isShort)
        case 6:
            strWeekday = Weekdays.Friday.description(isShort: isShort)
        case 7:
            strWeekday = Weekdays.Saturday.description(isShort: isShort)
        default:
            break
        }
        
        return strWeekday
    }
    
    func createDaysList() -> (clendarDaysList: [CalendarDay], dayNamesList: [String], currentDay: Int) {
        var currentDay: Int = 0
        var calendarDaysList: [CalendarDay] = []
        var dayNamesList: [String] = []
        
        for dayNumber in 1...daysInMonth {
            let shortDayName = getWeekdayFromDay(dayNumber: dayNumber, isShort: true)
            let dayName = getWeekdayFromDay(dayNumber: dayNumber, isShort: false)
            
            var isSelected: Bool
            if dayNumber == day {
                currentDay = dayNumber-1
                isSelected = true
            }else {
                isSelected = false
            }
            
            calendarDaysList.append(CalendarDay(dayNumber: dayNumber, dayName: shortDayName, isSelected: isSelected))
            dayNamesList.append(dayName)
        }
        
        return (calendarDaysList, dayNamesList, currentDay)
    }
    
    
}

extension Calendar {
    func getDaysInMonth(date: Date) -> Int{
        let range = self.range(of: .day, in: .month, for: date)!
        return range.count
    }
}
