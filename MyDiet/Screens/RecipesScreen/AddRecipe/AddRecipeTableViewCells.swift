import UIKit

protocol AddRecipeTableViewCellDelegate {
    func checkButtonDidTap(indexPath: IndexPath)
    func minusButtonDidTap(indexPath: IndexPath)
    
    func textFieldDidBeginEditing(_ textField: UITextField, indexPath: IndexPath)
    func textFieldDidEndEditing(_ textField: UITextField, indexPath: IndexPath)
    
    func textViewDidBeginEditing(_ textView: UITextView, indexPath: IndexPath)
    func textViewDidEndEditing(_ textView: UITextView, indexPath: IndexPath)
    func textViewDidChange()
}

class AddRecipeTableViewCell2: UITableViewCell {
    
    enum  CellType{
        case name, ingredient, step
    }
    
    // MARK: - Views
    let textField: UITextField = {
        let field = UITextField()
        field.textColor = .primaryPlus
        field.tintColor = .primary
        field.autocorrectionType = .no
        field.borderStyle = .none
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.textColor = .placeholderText
        view.tintColor = .primary
        view.isScrollEnabled = false
        view.autocorrectionType = .no
        
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkAccessoryView: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .primary
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        return button
    }()
    
    let minusAccessoryView: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .red
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        return button
    }()
    
    
    // MARK: - Properties
    var type: CellType?
    var placeholder: String?
    var indexPath: IndexPath?
    
    var delegate: AddRecipeTableViewCellDelegate?
    
    // MARK: - Overriden Functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
        textView.delegate = self
        
        checkAccessoryView.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
        minusAccessoryView.addTarget(self, action: #selector(minusButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    func setupView() {
        if type == .name {
            
            textField.placeholder = placeholder
            contentView.addSubview(textField)
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        }
        
        if type == .ingredient {
            
            textField.placeholder = placeholder
            contentView.addSubview(textField)
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
            
            accessoryView = minusAccessoryView
            
        }
        
        if type == .step {
            
            //contentView.removeFromSuperview()
            textView.text = placeholder
            textView.font = textField.font
            contentView.addSubview(textView)
            textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            accessoryView = minusAccessoryView
        }
    }
}

// MARK: - Actions
extension AddRecipeTableViewCell2 {
    @objc func checkButtonDidTap() {
        delegate?.checkButtonDidTap(indexPath: indexPath!)
    }
    
    @objc func minusButtonDidTap() {
        delegate?.minusButtonDidTap(indexPath: indexPath!)
    }
}

extension AddRecipeTableViewCell2: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField, indexPath: indexPath!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField, indexPath: indexPath!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing(textView, indexPath: indexPath!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing(textView, indexPath: indexPath!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newHieght = self.frame.size.height + textView.contentSize.height
        self.frame.size.height = newHieght
        
        delegate?.textViewDidChange()
    }
}

