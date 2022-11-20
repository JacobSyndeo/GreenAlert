import UIKit
import Soccer

public extension UIAlertAction {
    enum ActionType {
        case ok
        case cancel
    }
    
    enum Icon {
        case system(String)
        case custom(UIImage)
    }
    
    convenience init(title: String?,
                            style: Style,
                            icon: Icon?,
                            handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.icon = icon
    }
    
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
    
    func setSystemIconName(_ newValue: String) {
        setValue(UIImage(systemName: newValue)?.withRenderingMode(.alwaysTemplate), forKey: "image")
    }
    
    var textAlignmentMode: CATextLayerAlignmentMode? {
        get {
            value(forKey: "titleTextAlignment") as? CATextLayerAlignmentMode
        }
        set {
            setValue(newValue, forKey: "titleTextAlignment")
        }
    }
}

fileprivate struct CustomProperties {
    static var icon: UIAlertAction.Icon? = nil
}

extension UIAlertAction: SoccerPropertyStoring {
    public typealias T = Icon
    
    private var _icon: Icon? {
        get { // No stored property support in extensions? Pah, simpletons. Associated Objects to the rescue!
            return getAssociatedObject(&CustomProperties.icon)
        }
        set { // All hail the Obj-C runtime!
            return objc_setAssociatedObject(self, &CustomProperties.icon, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
