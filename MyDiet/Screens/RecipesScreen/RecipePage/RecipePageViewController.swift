import UIKit

enum ListType: String {
    case Ingredients = "Ingredients"
    case Steps = "Steps"
}

class RecipePageViewController: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var ingredientsButtonView: SearchButton!
    @IBOutlet var stepsButtonView: SearchButton!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var stepsTextView: UITextView!
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ingredientsButtonAction(_ sender: Any) {
        currentListType = .Ingredients
        updateContent()
    }
    
    @IBAction func stepsButtonAction(_ sender: Any) {
        currentListType = .Steps
        updateContent()
    }
    
    var currentListType: ListType!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameLabel.text = recipe.name
        
        currentListType = .Ingredients
        
        updateContent()
        
        ingredientsTextView.text = makeTextViewString(for: .Ingredients)
        
        stepsTextView.text = makeTextViewString(for: .Steps)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        topView.layer.cornerRadius = topView.frame.height/2/2
    }
    
    func updateContent() {
        let ingredientsLabel = ingredientsButtonView.subviews.first as! UILabel
        let stepsLabel = stepsButtonView.subviews.first as! UILabel
        
        switch currentListType {
            
        case .Ingredients:
            ingredientsTextView.isHidden = false
            ingredientsLabel.textColor = UIColor(named: "primaryColor")
            
            stepsTextView.isHidden = true
            stepsLabel.textColor = UIColor(named: "primaryLightColor")
        case .Steps:
            ingredientsTextView.isHidden = true
            ingredientsLabel.textColor = UIColor(named: "primaryLightColor")
            
            stepsTextView.isHidden = false
            stepsLabel.textColor = UIColor(named: "primaryColor")
        case .none: break
        }
        
    }
    
    func makeTextViewString(for listType: ListType) -> String {
        var finalString = ""
        
        switch listType {
        case .Ingredients:
            var ingredients: [String]!
            do {
                try ingredients = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(recipe.ingredients!) as? [String]
            } catch {}
            
            var counter = 1
            ingredients.forEach({ ingredient in
                finalString = finalString + "\(counter). " + ingredient + "\n\n"
                counter += 1
            })
        case .Steps:
            var steps: [String]!
            do {
                try steps = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(recipe.steps!) as? [String]
            } catch {}
            
            var counter = 1
            steps.forEach({ step in
                finalString = finalString + "\(counter). " + step + "\n\n"
                counter += 1
            })
        }
        
        return finalString
    }
    
}
