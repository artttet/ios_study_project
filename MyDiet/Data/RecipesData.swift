import UIKit
import CoreData

class RecipesScreenDataManager {
    
    static let instance = RecipesScreenDataManager()
    
    func getRecipeList(withSortKey key: String) -> [Recipe] {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: key)
    
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        return fetchedController.fetchedObjects as! [Recipe]
    }
    
    func addRecipe(recipe: Recipe) {
        var fetchedObjects = getRecipeList(withSortKey: "name")
        
        fetchedObjects.append(recipe)
        
        CoreDataManager.instance.saveContext(forEntity: Entity.Recipe)
    }
    
    func deleteRecipe(at index: Int, withSortKey key: String) {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: key)
        
        do {
            try fetchedController.performFetch()
        } catch { print(error) }
        
        let managedObject = fetchedController.object(at: IndexPath(row: index, section: 0)) as! NSManagedObject
        
        CoreDataManager.instance.deleteObject(forEntity: Entity.Recipe, object: managedObject)
    }
    
//    func changeRecipe(at index: Int, name: String, category: String, ingredients: Data, steps: Data) {
//        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: .Recipe, keyForSort: "name")
//        
//        do {
//            try fetchedController.performFetch()
//        } catch { print(error) }
//        
//        let recipe = fetchedController.object(at: IndexPath(row: index, section: 0)) as! Recipe
//        print(recipe.name)
//        
//        
//        recipe.name = name
//        recipe.category = category
//        recipe.ingredients = ingredients
//        recipe.steps = steps
//        
//       
//        
//        CoreDataManager.instance.saveContext(forEntity: .Recipe)
//        
//    }
}

extension RecipesScreenDataManager {
    
    func createStartRecipes() {
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
        
        let categories = [
            "Завтрак",
            "Обед",
            "Ужин",
            "Завтрак",
            "Обед",
            "Ужин",
            "Завтрак",
            "Обед",
            "Ужин",
        ]
        
        let ingredients: [[String]] = [
            [],
            [
                "Куриное филе - 2 шт.",
                "Гречневая крупа - 200 г.",
                "Лук репчатый - 1 шт.",
                "Морковь - 1 шт.",
                "Хмели-сунели - 1 ч.л.",
                "Петрушка - 2 ст.л",
                "Укроп - 2 ст.л"
            ],
            [
                "Чечевица коричневая - 100 г.",
                "Помидор - 1.5 шт.",
                "Огурец - 1.5 шт.",
                "Кинза - 1.5 ст.л",
                "Редис - 4 шт.",
                "Лук зеленый - 3 ст.л"
            ],
            [],
            [
                "Шампиньоны - 200 г.",
                "Морковь - 1 шт.",
                "Лук репчатый - 1 шт.",
                "Чеснок - 1.5 зубчика",
                "Молоко - 200 мл.",
                "Масло - 1 ст.л",
                "Специи (куркума и перец)"
            ],
            [
                "Свекла - 1 шт.",
                "Помидор - 2 шт.",
                "Авокадо - 1 шт.",
                "Шпинат - 50 гр.",
                "Масло - 1 ст.л",
                "Бальзамический уксус - 1 ст.л",
                "Специи (куркума и перец)"
            ],
            [
                "Творог - 100 г.",
                "Авокадо - 1 шт.",
                "Рукколв - 1 ст.л"
            ],
            [
                "Шампиньоны - 300 гр.",
                "Фасоль зелёная стручковая - 200 гр.",
                "Помидоры черри - 100 гр.",
                "Лимон - 0.5 шт.",
                "Кунжут чёрный - 1 ч.л.",
                "Специи (куркума и перец)"
            ],
            [
                "Руккола - 80 гр.",
                "Морковь - 1 шт.",
                "Капуста - 100 гр.",
                "Лук красный - 1 шт.",
                "Груша - 60 гр.",
                "Бальзамический уксус - 2 ч.л.",
                "Масло - 1 ст.л."
            ]
        ]
        
        let steps: [[String]] = [
            [],
            [
                "Куриное филе разрезать на небольшие кусочки. Лук и морковь мелко нарубить.",
                "В глубокой сковороде обжарить до мягкости лук и морковь. Добавить куриное филе и тушить пять минут.",
                "Добавить промытую гречку и налить столько воды, чтобы она покрывала крупу, перемешать. Дождаться пока вода закипит.",
                "Добавить хмели-сунели. Накрыть крышкой и тушить до готовности гречки, добавляя воду при необходимости.",
                "Посыпать блюдо мелко нарезанной зеленью."
            ],
            [
                "Чечевицу отварить до готовности.",
                "Остальное мелко нарезать.",
                "Смешать всё."
            ],
            [],
            [
                "Нарезать лук. Нарезать морковь.",
                "Обжарить лук и морковь в кастрюле с маслом. Немного потушить овощи под крышкой.",
                "Нарезать грибы. Добавить грибы к луку с морковью.",
                "Выдавить чеснок, посыпать специями.",
                "Всё перемешать, накрыть крышкой и тушить на средне-медленном огне минут 15-20.",
                "Когда всё протушится, снять с огня и взбить блендером.",
                "Нагреть молоко, но не кипятить. Добавить молоко к грибам с овощами.",
                "Всё взбить до однородной массы. Можно добавить зелень."
            ],
            [
                "Отварить свёклу до готовности. Остудить, нарезать небольшими кусочками.",
                "Такими же кусочками нарезать помидоры и авокадо.",
                "Смешать всё.",
                "Полить салат маслом и уксусом, добавить специи."
            ],
            [
                "Нарезать. Перемешать"
            ],
            [
                "Нарезанный шампиньоны на четвертинки, сбрызнуть лимонным соком. Обжарить шампиньоны на сковородке на среднем огне до образования корочки.",
                "Добавить в сковородку зелёную фасоль, добавить специи и продолжать обжаривать 5-7 минут. Выключить огонь, накрыть крышкой и оставить на минуты 3.",
                "Добавить нарезанным пополам Черри, сверху посыпать чёрным кунжутом."
            ],
            [
                "Капусту тонко нарезать и немного помять руками.",
                "Морковь почистить и натрите на крупной терке. Добавить к капусте и перемешать.",
                "Добавить резаный лук.",
                "Рукколу сполоснуть, стряхнуть воду и добавить в салат. Перемешать.",
                "Вымыть грушу и натереть на крупной тёрке. Перемешать.",
                "Полить бальзамическим соусом, маслом и перемешать.",
            ]
        ]
        
        for i in 0...8 {
            let recipe = Recipe()
            
            recipe.name = names[i]
            recipe.category = categories[i]
            
            do {
                try recipe.ingredients = NSKeyedArchiver.archivedData(withRootObject: ingredients[i], requiringSecureCoding: false)
                try recipe.steps = NSKeyedArchiver.archivedData(withRootObject: steps[i], requiringSecureCoding: false)
            } catch {}
            
            CoreDataManager.instance.saveContext(forEntity: .Recipe)
        }
        
    }
    
}
