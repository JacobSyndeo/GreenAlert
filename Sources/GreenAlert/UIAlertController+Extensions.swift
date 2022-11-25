import UIKit
import SafeSubscripts

@MainActor
public extension UIAlertController {
    enum AlertStyle {
        case alert
        case actionSheet(source: Source) // You need a source to use an action sheet!
        
        public enum Source {
            case view(UIView, CGRect = CGRect.null)
            case barButtonItem(UIBarButtonItem)
            
            static func optional(view: UIView?, rect: CGRect? = CGRect.null) -> Source? {
                guard let view = view, let rect = rect else { return nil }
                return .view(view, rect)
            }
            
            static func optional(barButtonItem: UIBarButtonItem?) -> Source? {
                guard let barButtonItem = barButtonItem else { return nil }
                return .barButtonItem(barButtonItem)
            }
        }
    }
    
    class func showBasicAlert(_ title: String,
                              message: String,
                              actionIcon: UIAlertAction.Icon? = nil,
                              preferredAlertStyle: AlertStyle = .alert,
                              presentingViewController: UIViewController? = nil,
                              callback: (() -> ())? = nil) {
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
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
    
    class func showOKCancelAlert(_ title: String,
                                 message: String,
                                 cancelButtonText: String = "Cancel",
                                 okButtonText: String = "OK",
                                 okActionStyle: UIAlertAction.Style = .default,
                                 okActionIcon: UIAlertAction.Icon? = nil,
                                 preferredAction: UIAlertAction.ActionType = .cancel,
                                 preferredAlertStyle: AlertStyle = .alert,
                                 presentingViewController: UIViewController? = nil,
                                 callback:@escaping (_ confirmed: Bool) -> ()) {
        
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel) { _ in
            callback(false)
        }
        
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
    
    func addProgressBar() -> UIProgressView {
        let margin: CGFloat = 8
        let height: CGFloat = 2
        
        let rect = CGRect(x: margin,
                          y: view.frame.height - margin - height,
                          width: view.frame.width - (margin * 2),
                          height: height)
        let progressBar = UIProgressView(frame: rect)
//        progressBar.tintColor = TintColor.current.color
        view.addSubview(progressBar)
        return progressBar // For later modification as needed
    }
    
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
    
    private func andPresent(presentingViewController: UIViewController? = nil, presentionCompletion: (() -> ())? = nil) {
        guard let presentingViewController = presentingViewController else {
            UIAlertController.presentOnTopVC(self, animated: true, completion: presentionCompletion)
            return
        }
        
        presentingViewController.present(self, animated: true, completion: presentionCompletion)
    }
    
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

// TODO: either import EZSE or migrate away
public extension UIApplication {
    /// EZSE: Run a block in background after app resigns activity
    func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }

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
