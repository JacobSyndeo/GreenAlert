//
//  GreenAlert-Async.swift
//  GreenAlert
//
//  Created by Jacob Pritchett on 11/24/22.
//

import UIKit

public extension UIAlertController {
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
