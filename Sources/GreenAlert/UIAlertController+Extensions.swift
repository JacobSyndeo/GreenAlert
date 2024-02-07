import UIKit
import SafeSubscripts

/// A collection of extensions for `UIAlertController`.
@MainActor
public extension UIAlertController {
    /// The style of the alert.
    enum AlertStyle {
        /// A standard alert.
        case alert
        /// An action sheet.
        /// - Parameter source: The source of the action sheet. This is required for iPads.
        case actionSheet(source: Source) // You need a source to use an action sheet!
        
        public enum Source {
            /// The source view and rect for the action sheet.
            case view(UIView, CGRect = CGRect.null)
            /// The source bar button item for the action sheet.
            case barButtonItem(UIBarButtonItem)
            
            /// An "optional initializer" for Source. If the view or rect is `nil`, the source will be `nil`.
            /// - Parameters:
            ///   - view: The source view.
            ///   - rect: The source rect. Default is `CGRect.null`.
            /// - Returns: The source, or `nil` if the view or rect is `nil`.
            static func optional(view: UIView?, rect: CGRect? = CGRect.null) -> Source? {
                guard let view = view, let rect = rect else { return nil }
                return .view(view, rect)
            }
            
            /// An "optional initializer" for Source. If the bar button item is `nil`, the source will be `nil`.
            /// - Parameter barButtonItem: The bar button item to use as the source.
            /// - Returns: The source, or `nil` if the bar button item is `nil`.
            static func optional(barButtonItem: UIBarButtonItem?) -> Source? {
                guard let barButtonItem = barButtonItem else { return nil }
                return .barButtonItem(barButtonItem)
            }
        }
    }
    
    /// Shows a basic alert with a single "OK" button.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - buttonText: The text of the button. Default is "OK".
    ///   - actionStyle: The style of the button. Default is `.default`.
    ///   - actionIcon: The icon of the button. Default is `nil`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    ///   - presentingViewController: If you want to present the alert on a specific view controller, you can specify it here. If left as the default `nil`, the alert will be presented on the top view controller.
    ///   - callback: The callback to be called when the button is tapped. Default is `nil`, meaning nothing happens when the button is tapped.
    class func showBasicAlert(_ title: String,
                              message: String,
                              buttonText: String = "OK",
                              actionStyle: UIAlertAction.Style = .default,
                              actionIcon: UIAlertAction.Icon? = nil,
                              preferredAlertStyle: AlertStyle = .alert,
                              presentingViewController: UIViewController? = nil,
                              callback: (() -> ())? = nil) {

        let okAction = UIAlertAction(title: buttonText, style: actionStyle) { _ in
            callback?()
        }
        
        okAction.icon = actionIcon
        
        let alertController = buildAlert(title,
                                         message: message,
                                         actions: [okAction],
                                         preferredAlertStyle: preferredAlertStyle)

        guard let presentingViewController = presentingViewController else {
            presentOnTopVC(alertController)
            return
        }
        
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
    
    
    /// Shows an alert with "OK" and "Cancel" buttons.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - cancelButtonText: The text of the cancel button. Default is "Cancel".
    ///   - cancelActionStyle: The style of the cancel button. Default is `.cancel`.
    ///   - cancelActionIcon: The icon of the cancel button. Default is `nil`.
    ///   - okButtonText: The text of the OK button. Default is "OK".
    ///   - okActionStyle: The style of the OK button. Default is `.default`.
    ///   - okActionIcon: The icon of the OK button. Default is `nil`.
    ///   - preferredAction: The preferred action. This information is passed to the `UIAlertController` instance, which will then give the action more visual prominence. Default is `.cancel`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    ///   - presentingViewController: If you want to present the alert on a specific view controller, you can specify it here. If left as the default `nil`, the alert will be presented on the top view controller.
    ///   - callback: The callback to be called, with a boolean indicating whether the OK button (true) or the Cancel button (false) was tapped.
    class func showOKCancelAlert(_ title: String,
                                 message: String,
                                 cancelButtonText: String = "Cancel",
                                 cancelActionStyle: UIAlertAction.Style = .cancel,
                                 cancelActionIcon: UIAlertAction.Icon? = nil,
                                 okButtonText: String = "OK",
                                 okActionStyle: UIAlertAction.Style = .default,
                                 okActionIcon: UIAlertAction.Icon? = nil,
                                 preferredAction: UIAlertAction.ActionType = .cancel,
                                 preferredAlertStyle: AlertStyle = .alert,
                                 presentingViewController: UIViewController? = nil,
                                 callback:@escaping (_ confirmed: Bool) -> ()) {
        
        let cancelAction = UIAlertAction(title: cancelButtonText, style: cancelActionStyle) { _ in
            callback(false)
        }

        cancelAction.icon = cancelActionIcon

        let okAction = UIAlertAction(title: okButtonText, style: okActionStyle) { _ in
            callback(true)
        }
        
        okAction.icon = okActionIcon
        
        buildAlert(title,
                   message: message,
                   actions: [cancelAction, okAction],
                   preferredActionIndex: preferredAction == .ok ? 1 : 0,
                   preferredAlertStyle: preferredAlertStyle)
            .andPresent(presentingViewController: presentingViewController)
    }
    
    /// Shows an alert with custom actions.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - actions: The actions to be displayed in the alert.
    ///   - preferredActionIndex: Allows you to specify which action should be the preferred action. This information is passed to the `UIAlertController` instance, which will then give the action more visual prominence. Default is `nil`.
    ///   - textFieldConfigurationHandler: If not `nil`, the alert will contain a text field with the given configuration. Default is `nil`.
    ///   - contentViewController: A view controller to be displayed in the alert. Default is `nil`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    ///   - presentingViewController: If you want to present the alert on a specific view controller, you can specify it here. If left as the default `nil`, the alert will be presented on the top view controller.
    ///   - presentionCompletion: The completion handler to be called when the alert is presented. Default is `nil`.
    class func showCustomAlert(_ title: String,
                               message: String? = nil,
                               actions: [UIAlertAction],
                               preferredActionIndex: Int? = nil,
                               textFieldConfigurationHandler: ((UITextField) -> ())? = nil,
                               contentViewController: UIViewController? = nil,
                               preferredAlertStyle: AlertStyle = .alert,
                               presentingViewController: UIViewController? = nil,
                               presentionCompletion: (() -> ())? = nil) {
        
        buildAlert(title,
                   message: message,
                   actions: actions,
                   preferredActionIndex: preferredActionIndex,
                   textFieldConfigurationHandler: textFieldConfigurationHandler,
                   contentViewController: contentViewController,
                   preferredAlertStyle: preferredAlertStyle)
            .andPresent(presentingViewController: presentingViewController,
                        presentionCompletion: presentionCompletion)
    }
    
    /// Shows a prompt for a value.
    /// - Parameters:
    ///   - title: The title of the prompt.
    ///   - message: The message of the prompt.
    ///   - presetText: The text to be pre-filled in the text field. Default is an empty string.
    ///   - placeHolder: The placeholder of the text field. Default is an empty string.
    ///   - keyboardType: The keyboard type of the text field. Default is `.asciiCapable`.
    ///   - cancelButtonText: The text of the cancel button. Default is "Cancel".
    ///   - okButtonText: The text of the OK button. Default is "OK".
    ///   - okActionStyle: The style of the OK button. Default is `.default`.
    ///   - okActionIcon: The icon of the OK button. Default is `nil`.
    ///   - preferredAction: The preferred action. This information is passed to the `UIAlertController` instance, which will then give the action more visual prominence. Default is `.cancel`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    ///   - presentingViewController: If you want to present the alert on a specific view controller, you can specify it here. If left as the default `nil`, the alert will be presented on the top view controller.
    ///   - callback: The callback to be called, with the text entered by the user, or `nil` if the user tapped the cancel button.
    class func showPromptForValue(_ title: String,
                                  message: String,
                                  presetText: String = "",
                                  placeHolder: String = "",
                                  keyboardType: UIKeyboardType = .asciiCapable,
                                  cancelButtonText: String = "Cancel",
                                  okButtonText: String = "OK",
                                  okActionStyle: UIAlertAction.Style = .default,
                                  okActionIcon: UIAlertAction.Icon? = nil,
                                  preferredAction: UIAlertAction.ActionType = .cancel,
                                  preferredAlertStyle: AlertStyle = .alert,
                                  presentingViewController: UIViewController? = nil,
                                  callback: @escaping (_ text: String?) -> Void) {
        
        // Allow the okAction handler to obtain a reference.
        var alertController = UIAlertController() // The UIAlertController instance will be different than this, but the pointer will point to the correct one (from buildAlert()) at runtime!
        
        let okAction = UIAlertAction(title: okButtonText, style: okActionStyle) { _ in
            guard let textField = alertController.textFields?[safe: 0] else { return }
            callback(textField.text)
        }
        
        let cancelAction = UIAlertAction(title: cancelButtonText, style: UIAlertAction.Style.cancel, handler: { _ -> () in
            callback(nil)
        })
        
        okAction.icon = okActionIcon
        
        // To properly update the pointer for okAction to use
        alertController = buildAlert(title,
                                     message: message,
                                     actions: [cancelAction, okAction],
                                     preferredActionIndex: preferredAction == .ok ? 1 : 0,
                                     textFieldConfigurationHandler: { (textField: UITextField!) -> () in
                                        textField.text = presetText
                                        textField.placeholder = placeHolder
                                        textField.keyboardType = keyboardType
                                     },
                                     preferredAlertStyle: preferredAlertStyle)
        alertController.andPresent()
    }
    
    /// Adds a progress bar to the alert.
    /// - Returns: The progress bar that was added to the alert.
    func addProgressBar() -> UIProgressView {
        let margin: CGFloat = 8
        let height: CGFloat = 2
        
        let rect = CGRect(x: margin,
                          y: view.frame.height - margin - height,
                          width: view.frame.width - (margin * 2),
                          height: height)
        let progressBar = UIProgressView(frame: rect)
        view.addSubview(progressBar)
        return progressBar // For later modification as needed
    }
    
    /// Builds an alert with the given parameters.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - actions: The actions to be displayed in the alert.
    ///   - preferredActionIndex: Allows you to specify which action should be the preferred action. This information is passed to the `UIAlertController` instance, which will then give the action more visual prominence. Default is `nil`.
    ///   - textFieldConfigurationHandler: If not `nil`, the alert will contain a text field with the given configuration. Default is `nil`.
    ///   - contentViewController: A view controller to be displayed in the alert. Default is `nil`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    /// - Returns: The alert controller that was built.
    private class func buildAlert(_ title: String,
                                  message: String? = nil,
                                  actions: [UIAlertAction],
                                  preferredActionIndex: Int? = nil,
                                  textFieldConfigurationHandler: ((UITextField) -> ())? = nil,
                                  contentViewController: UIViewController? = nil,
                                  preferredAlertStyle: AlertStyle = .alert) -> UIAlertController {
        let alertStyleToUse: UIAlertController.Style // Apple's type, not ours
        
        // Re-cast to Apple's type in order to pass it into Apple's initializer below.
        switch preferredAlertStyle {
        case .alert:
            alertStyleToUse = .alert
        case .actionSheet(source: _):
            alertStyleToUse = .actionSheet
        }
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: alertStyleToUse)
        
        if let textFieldConfigurationHandler = textFieldConfigurationHandler {
            alertController.addTextField(configurationHandler: textFieldConfigurationHandler)
        }
        
        if contentViewController != nil {
            alertController.setValue(contentViewController, forKey: "contentViewController")
        }
        
        actions.forEach { (action) in
            alertController.addAction(action)
        }
        
        if let preferredActionIndex = preferredActionIndex {
            alertController.preferredAction = actions[safe: preferredActionIndex]
        }
        
        // Action Sheets need source UIView+CGRects or a source UIBarButtonItem to work on iPads.
        switch preferredAlertStyle {
        case .actionSheet(source: let source):
            switch source {
            case let .view(sourceView, sourceRect):
                alertController.popoverPresentationController?.sourceView = sourceView
                alertController.popoverPresentationController?.sourceRect = sourceRect
            case let .barButtonItem(sourceBarButtonItem):
                alertController.popoverPresentationController?.barButtonItem = sourceBarButtonItem
            }
        default: ()
        }
        
        return alertController
    }
    
    /// Presents the alert on the given view controller, or on the top view controller if none is given.
    /// - Parameters:
    ///   - presentingViewController: The view controller on which to present the alert. If left as the default `nil`, the alert will be presented on the top view controller.
    ///   - presentionCompletion: The completion handler to be called when the alert is presented. Default is `nil`.
    func andPresent(presentingViewController: UIViewController? = nil, presentionCompletion: (() -> ())? = nil) {
        guard let presentingViewController = presentingViewController else {
            UIAlertController.presentOnTopVC(self, animated: true, completion: presentionCompletion)
            return
        }
        
        presentingViewController.present(self, animated: true, completion: presentionCompletion)
    }
    
    /// Presents the alert on the top view controller.
    /// - Parameters:
    ///   - alertController: The alert controller to be presented.
    ///   - animated: Whether to animate the presentation. Default is `true`.
    ///   - completion: The completion handler to be called when the alert is presented. Default is `nil`.
    class func presentOnTopVC(_ alertController: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
        Task {
            await MainActor.run {
                if alertController.preferredStyle == .actionSheet,
                   let popoverController = alertController.popoverPresentationController,
                   let sourceRect = UIApplication.topViewController()?.view.bounds {
                    popoverController.sourceView = UIApplication.topViewController()?.view
                    popoverController.sourceRect = sourceRect
                    popoverController.permittedArrowDirections = []
                }
                
                UIApplication.topViewController()?.present(alertController, animated: true, completion: completion)
            }
        }
    }
}

fileprivate extension UIApplication {
    /// EZSE: Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
