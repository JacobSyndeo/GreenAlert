import UIKit
import Soccer

/// A collection of extensions for `UIAlertAction`.
public extension UIAlertAction {
    /// The type of action that the alert action represents.
    enum ActionType {
        case ok
        case cancel
    }
    
    /// An enum representing the type of icon that the alert action should display.
    enum Icon {
        /// An icon from the system's SF Symbols library.
        case system(String)
        /// A custom image to be used as the icon.
        case custom(UIImage)
    }
    
    /// A convenience initializer for creating an alert action with an icon.
    /// - Parameters:
    ///   - title: The title of the alert action.
    ///   - style: The style of the alert action.
    ///   - icon: The icon to be displayed alongside the alert action's title.
    ///   - handler: The closure to be executed when the alert action is tapped.
    convenience init(title: String?,
                     style: Style,
                     icon: Icon?,
                     handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.icon = icon
    }
    
    /// The icon to be displayed alongside the alert action's title.
    var icon: Icon? {
        get {
            _icon // Store it, so we can properly return it (accurately remembering the system/custom type)
        }
        set {
            _icon = newValue
            
            let image: UIImage?
            
            switch newValue {
            case .system(let name):
                image = UIImage(systemName: name)?.withRenderingMode(.alwaysTemplate)
            case .custom(let customImage):
                image = customImage
            case .none:
                image = nil
            }
            
            setValue(image?.withRenderingMode(.alwaysTemplate), forKey: "image")
        }
    }
    
    /// A convenience method for setting the icon of the alert action to a system icon.
    func setSystemIconName(_ newValue: String) {
        setValue(UIImage(systemName: newValue)?.withRenderingMode(.alwaysTemplate), forKey: "image")
    }
    
    /// An accessor for the text alignment mode of the alert action's title.
    var textAlignmentMode: CATextLayerAlignmentMode? {
        get {
            value(forKey: "titleTextAlignment") as? CATextLayerAlignmentMode
        }
        set {
            setValue(newValue, forKey: "titleTextAlignment")
        }
    }
}

// MARK: - SoccerPropertyStoring
fileprivate struct CustomProperties {
    static var icon: UIAlertAction.Icon? = nil
}

/// A protocol for storing properties in extensions.
extension UIAlertAction: SoccerPropertyStoring {
    public typealias T = Icon
    
    /// The icon to be displayed alongside the alert action's title.
    private var _icon: Icon? {
        get { // No stored property support in extensions? Pah, simpletons. Associated Objects to the rescue!
            return getAssociatedObject(&CustomProperties.icon)
        }
        set { // All hail the Obj-C runtime!
            return setAssociatedObject(&CustomProperties.icon, newValue: newValue)
        }
    }
}
