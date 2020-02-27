import UIKit

extension NSNotification.Name {
    static let reloadCardsPagerView = NSNotification.Name.init("ReloadCardsPagerView")
}

extension String {
    static func localized(_ stringKey: String) -> String {
        return NSLocalizedString(stringKey, comment: "")
    }
}

extension UIColor {
    static let primary = UIColor(named: "primaryColor")!
    static let primaryDark = UIColor(named: "primaryDarkColor")!
    static let primaryLight = UIColor(named: "primaryLightColor")!
    static let primaryPlus = UIColor(named: "primaryPlusColor")!
    static let accent = UIColor(named: "accentColor")!
    static let background = UIColor(named: "backgroundColor")!
}

extension UIFont {
    static let screenTitle = UIFont(name: "Futura-Bold", size: 34.0)!
    static let monthLabel = UIFont.TextStyle.headline
}

extension UIImage.SymbolConfiguration {
    static let buttonImageConfiguration = UIImage.SymbolConfiguration.init(font: .screenTitle, scale: .small)
}

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
