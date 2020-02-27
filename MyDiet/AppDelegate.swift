import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstLaunchKey = "FirstLaunchKey"
        
        if UserDefaults.standard.bool(forKey: firstLaunchKey) {
            
        let appDayList = TodayScreenDataManager.instance.getAppDayList(withSortKey: "dayNumber")
        appDayList.forEach({ day in
            if day.isSelected {
                if day.dayNumber != AppCalendar.instance.day {
                    TodayScreenDataManager.instance.changeIsSelected(at: Int(day.dayNumber-1), state: false)
                    TodayScreenDataManager.instance.changeIsSelected(at: AppCalendar.instance.day-1, state: true)
                }
            }
        })
            
        }else {
            UserDefaults.standard.setValue(true, forKey: firstLaunchKey)
            RecipesScreenDataManager.instance.createStartRecipes()
            TodayScreenDataManager.instance.createStartDishes()
            TodayScreenDataManager.instance.createAppDays()
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        CoreDataManager.instance.saveContext(forEntity: nil)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

