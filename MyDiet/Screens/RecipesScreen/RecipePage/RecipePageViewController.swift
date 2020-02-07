import UIKit

enum ListType: String {
    case Ingredients = "Ingredients"
    case Steps = "Steps"
}

class RecipePageViewController: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var ingredientsButtonView: MyButton!
    @IBOutlet var stepsButtonView: MyButton!
    @IBOutlet var ingredientsTextView: UITextView!
    @IBOutlet var stepsTextView: UITextView!
    @IBOutlet var stackView: UIStackView!
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ingredientsButtonAction(_ sender: Any) {
        moveDot(to: .Ingredients)
        currentListType = .Ingredients
        updateContent()
    }
    
    @IBAction func stepsButtonAction(_ sender: Any) {
        moveDot(to: .Steps)
        currentListType = .Steps
        updateContent()
    }
    
    var dotViewStartPosition: [CGFloat] = []
    var dotViewEndPosition: [CGFloat] = []
    
    var dotView: UIView!
    
    var currentListType: ListType!
    
    var recipe: Recipe!
    
    var style: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.style = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        recipeNameLabel.text = recipe.name
        
        currentListType = .Ingredients
        
        updateContent()
        
        ingredientsTextView.text = makeTextViewString(for: .Ingredients)
        
        stepsTextView.text = makeTextViewString(for: .Steps)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        topView.layer.cornerRadius = topView.frame.height/4
        
        ingredientsButtonView.layer.maskedCorners = [.layerMinXMaxYCorner]
        ingredientsButtonView.layer.cornerRadius = ingredientsButtonView.frame.height/2
        
        stepsButtonView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        stepsButtonView.layer.cornerRadius = stepsButtonView.frame.height/2
        
        if dotView == nil {
            dotView = makeDot()
            dotView.backgroundColor = UIColor(named: "primaryColor")
            dotView.layer.cornerRadius = 4
            
            stackView.addSubview(dotView)
        }
    }
    
    func makeDot() -> UIView {
        dotViewStartPosition.append(ingredientsButtonView.frame.origin.x + ingredientsButtonView.frame.width/2 - 4)
        dotViewStartPosition.append(ingredientsButtonView.frame.origin.y + ingredientsButtonView.frame.height/2 + 12)
        
        dotViewEndPosition.append(stepsButtonView.frame.origin.x + stepsButtonView.frame.width/2 - 4)
        dotViewEndPosition.append(stepsButtonView.frame.origin.y + stepsButtonView.frame.height/2 + 12)
        
        return UIView(frame: CGRect(x: dotViewStartPosition[0], y: dotViewStartPosition[1], width: 8.0, height: 8.0))
    }

    func moveDot(to item: ListType) {
        var dotViewTmpPosition: [CGFloat]!
        
        if item == currentListType {
            return
        }
        
        ingredientsButtonView.isUserInteractionEnabled = false
        stepsButtonView.isUserInteractionEnabled = false
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                dotViewTmpPosition = self.dotViewStartPosition
                if let view = self.dotView {
                    view.frame.origin.x = self.dotViewEndPosition[0]
                    view.frame.origin.y = self.dotViewEndPosition[1]
                }
            },
            completion: { _ in
                self.dotViewStartPosition = self.dotViewEndPosition
                self.dotViewEndPosition = dotViewTmpPosition
                
                self.ingredientsButtonView.isUserInteractionEnabled = true
                self.stepsButtonView.isUserInteractionEnabled = true
            }
        )
    }
    
    func updateContent() {
        let ingredientsLabel = ingredientsButtonView.subviews.first as! UILabel
        let stepsLabel = stepsButtonView.subviews.first as! UILabel
        
        switch currentListType {
            
        case .Ingredients:
            ingredientsTextView.isHidden = false
            ingredientsLabel.textColor = UIColor(named: "primaryColor")
            
            stepsTextView.isHidden = true
            stepsLabel.textColor = UIColor.white
        case .Steps:
            ingredientsTextView.isHidden = true
            ingredientsLabel.textColor = UIColor.white
            
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
