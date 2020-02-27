import UIKit

protocol PickerStackViewDelegate {
    func cancelButtonDidTap()
    func readyButtonDidTap()
}

class PickerStackView: UIStackView {
    // MARK: - Views
    let cancelButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(.localized("Cancel"), for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    let readyButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(.localized("Ready"), for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.addTarget(self, action: #selector(readyButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    var topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 16.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    // MARK: - Properties
    var delegate: PickerStackViewDelegate?
    
    var titles: [String]!
    
    var state: Bool!
    var yPositionOn: CGFloat!
    var yPositionOff: CGFloat!
    
    // MARK: - Overriden Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .fill
        distribution = .fill
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    func updateTitles(to newTitles: [String]?, with selectedIndex: Int) {
        if let titles = newTitles { self.titles = titles }
        pickerView.reloadComponent(0)
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
    
    func selectedRow() -> Int {
        return pickerView.selectedRow(inComponent: 0)
    }
    
}

// MARK: - Setup Views
extension PickerStackView {
    
    func setupViews() {
        topStackView.addArrangedSubview(cancelButton)
        topStackView.addArrangedSubview(readyButton)
        
        topBackgroundView.addSubview(topStackView)
        
        addArrangedSubview(topBackgroundView)
        
        addArrangedSubview(pickerView)
    }
    
    func setupConstraints() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.leadingAnchor.constraint(equalTo: topBackgroundView.leadingAnchor, constant: 16.0).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: topBackgroundView.trailingAnchor, constant: -16.0).isActive = true
        topStackView.centerYAnchor.constraint(equalTo: topBackgroundView.centerYAnchor).isActive = true
        
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        topBackgroundView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

// MARK: - Button Actions
extension PickerStackView {
    
    @objc func cancelButtonDidTap() {
        delegate?.cancelButtonDidTap()
    }
    
    @objc func readyButtonDidTap() {
        delegate?.readyButtonDidTap()
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension PickerStackView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let titles = self.titles {
            return titles.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = titles[row]
        
        let color = row == 0 ? UIColor.lightGray : UIColor.primary
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : color as Any])
        
        return attributedTitle
    }
}
