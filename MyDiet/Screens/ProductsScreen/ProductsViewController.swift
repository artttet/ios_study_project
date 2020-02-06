import UIKit
import BEMCheckBox

class ProductsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var plusButtonView: SearchButton!
    
    @IBAction func plusButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Добавить продукт", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
            let textField = alert.textFields![0] as UITextField
            if textField.text!.isEmpty {
                return
            } else {
                let product = Product()
                product.name = textField.text
                product.addDate = Date()
                
                ProductsScreenDataManager.instance.addProduct(product: product)
                
                self.updateTableView(withInsert: true)
            }
        }))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Введите продукт"
            textField.textColor = UIColor(named: "primaryColor")
        })
        
        alert.view.tintColor = UIColor(named: "primaryColor")
        
        self.present(alert, animated: true)
    }
    
    var productList: [Product] = []

    var style: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        productList = ProductsScreenDataManager.instance.getProductList(withSortKey: "addDate")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductsTableViewCell")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
                  self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint)  {
                let alert = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    ProductsScreenDataManager.instance.deleteProdutc(at: indexPath.row, withSortKey: "addDate")
                    self.productList = ProductsScreenDataManager.instance.getProductList(withSortKey: "addDate")
                    self.tableView.endUpdates()
                }))
                
                alert.view.tintColor = UIColor(named: "primaryColor")
                
                self.present(alert, animated: true)
            }
        }
    }
    
    func updateTableView(withInsert isInsert: Bool) {
        tableView.beginUpdates()
        productList = ProductsScreenDataManager.instance.getProductList(withSortKey: "addDate")
        if isInsert {
            tableView.insertRows(at: [IndexPath(row: productList.count-1, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func productStringAttributes(for state: Bool) -> [NSAttributedString.Key : Any?]{
        let strikethroughStyle = state ? NSUnderlineStyle.single.rawValue : NSUnderlineStyle.byWord.rawValue
        let strikethroughColor = state ? UIColor.lightGray : nil
        let textColor = state ? UIColor.lightGray : UIColor(named: "primaryColor")
        
        return [
            NSAttributedString.Key.strikethroughStyle : strikethroughStyle,
            NSAttributedString.Key.strikethroughColor : strikethroughColor,
            NSAttributedString.Key.foregroundColor : textColor
        ]
    }
}

// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Список продуктов"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath)
        
        let c = BEMCheckBox(frame: .init(x: 0, y: 0, width: 20, height: 20))
        let color = UIColor(named: "primaryColor")!
        c.tag = indexPath.row
        c.on = productList[indexPath.row].isHave
        c.tintColor = color
        c.onCheckColor = color
        c.onTintColor = color
        c.delegate = self
        
        cell.textLabel?.attributedText = NSAttributedString(string: productList[indexPath.row].name!, attributes: productStringAttributes(for: c.on) as [NSAttributedString.Key : Any])
        cell.backgroundColor = UIColor.white
        cell.accessoryView = c
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        let checkbox = cell.accessoryView as! BEMCheckBox
        checkbox.on = !checkbox.on
        
        cell.textLabel?.attributedText = NSAttributedString(string: productList[indexPath.row].name!, attributes: productStringAttributes(for: checkbox.on) as [NSAttributedString.Key : Any])
        ProductsScreenDataManager.instance.changeIsHave(in: checkbox.tag, to: checkbox.on)
            
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - BEMCheckBoxDelegate
extension ProductsViewController: BEMCheckBoxDelegate {
    func animationDidStop(for checkBox: BEMCheckBox) {
        let cell = tableView.cellForRow(at: IndexPath(row: checkBox.tag, section: 0))
        cell?.textLabel?.attributedText = NSAttributedString(string: (cell?.textLabel!.text)!, attributes: productStringAttributes(for: checkBox.on) as [NSAttributedString.Key : Any])
        
        ProductsScreenDataManager.instance.changeIsHave(in: checkBox.tag, to: checkBox.on)
    }
}
