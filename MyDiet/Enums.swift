import UIKit

enum Weekdays{
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    func description(isShort: Bool) -> String {
        switch self {
        case .Monday:
            if isShort{
                return "Пн"
            }else {
                return "Понедельник"
            }
        case .Tuesday:
            if isShort{
                return "Вт"
            }else {
                return "Вторник"
            }
        case .Wednesday:
            if isShort{
                return "Ср"
            }else {
                return "Среда"
            }
        case .Thursday:
            if isShort{
                return "Чт"
            }else {
                return "Четверг"
            }
        case .Friday:
            if isShort{
                return "Пт"
            }else {
                return "Пятница"
            }
        case .Saturday:
            if isShort{
                return "Сб"
            }else {
                return "Суббота"
            }
        case .Sunday:
            if isShort{
                return "Вс"
            }else {
                return "Воскресенье"
            }
        default:
            break
        }
    }
}
