//
//  GreenAlert-Async.swift
//  GreenAlert
//
//  Created by Jacob Pritchett on 11/24/22.
//

import UIKit

/// A collection of async/await extensions for `UIAlertController`.
public extension UIAlertController {
    /// Shows a basic alert with a single "OK" button.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - buttonText: The text of the button. Default is "OK".
    ///   - actionStyle: The style of the button. Default is `.default`.
    ///   - actionIcon: The icon of the button. Default is `nil`.
    ///   - preferredAlertStyle: The style of the alert. Default is `.alert`.
    ///   - presentingViewController: If you want to present the alert on a specific view controller, you can specify it here. If left as the default `nil`, the alert will be presented on the top view controller.
    class func showBasicAlert(_ title: String,
                              message: String,
                              buttonText: String = "OK",
                              actionStyle: UIAlertAction.Style = .default,
                              actionIcon: UIAlertAction.Icon? = nil,
                              preferredAlertStyle: AlertStyle = .alert,
                              presentingViewController: UIViewController? = nil) async {
        await withCheckedContinuation { continuation in
            showBasicAlert(title,
                           message: message,
                           buttonText: buttonText,
                           actionStyle: actionStyle,
                           actionIcon: actionIcon,
                           preferredAlertStyle: preferredAlertStyle,
                           presentingViewController: presentingViewController) {
                continuation.resume()
            }
        }
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
    /// - Returns: A boolean indicating whether the OK button (true) or the Cancel button (false) was tapped.
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
                                 presentingViewController: UIViewController? = nil) async -> Bool {
        await withCheckedContinuation { continuation in
            showOKCancelAlert(title,
                              message: message,
                              cancelButtonText: cancelButtonText,
                              cancelActionStyle: cancelActionStyle,
                              cancelActionIcon: cancelActionIcon,
                              okButtonText: okButtonText,
                              okActionStyle: okActionStyle,
                              okActionIcon: okActionIcon,
                              preferredAction: preferredAction,
                              preferredAlertStyle: preferredAlertStyle,
                              presentingViewController: presentingViewController) { confirmed in
                continuation.resume(returning: confirmed)
            }
        }
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
    class func showCustomAlert(_ title: String,
                               message: String? = nil,
                               actions: [UIAlertAction],
                               preferredActionIndex: Int? = nil,
                               textFieldConfigurationHandler: ((UITextField) -> ())? = nil,
                               contentViewController: UIViewController? = nil,
                               preferredAlertStyle: AlertStyle = .alert,
                               presentingViewController: UIViewController? = nil) async {
        await withCheckedContinuation { continuation in
            showCustomAlert(title,
                            message: message,
                            actions: actions,
                            preferredActionIndex: preferredActionIndex,
                            textFieldConfigurationHandler: textFieldConfigurationHandler,
                            contentViewController: contentViewController,
                            preferredAlertStyle: preferredAlertStyle,
                            presentingViewController: presentingViewController) {
                continuation.resume()
            }
        }
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
    /// - Returns: The text entered by the user, or `nil` if the user tapped the cancel button.
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
                                  presentingViewController: UIViewController? = nil) async -> String? {
        await withCheckedContinuation { continuation in
            showPromptForValue(title,
                               message: message,
                               presetText: presetText,
                               placeHolder: placeHolder,
                               keyboardType: keyboardType,
                               cancelButtonText: cancelButtonText,
                               okButtonText: okButtonText,
                               okActionStyle: okActionStyle,
                               okActionIcon: okActionIcon,
                               preferredAction: preferredAction,
                               preferredAlertStyle: preferredAlertStyle,
                               presentingViewController: presentingViewController) { text in
                continuation.resume(returning: text)
            }
        }
    }
}
