# ``GreenAlert``

## Welcome!

Welcome! This documentation is designed to help you get started with `GreenAlert` as quickly as possible, answer any questions you might have, and provide a reference for the API.

If you have any questions not covered here, feel free to [open an issue](https://github.com/JacobSyndeo/GreenAlert/issues/new)! I'll be happy to help. 🙂

By the way, don't be overwhelmed by the big method signatures listed here. `GreenAlert` follows the principle of _[progressive disclosure](https://en.wikipedia.org/wiki/Progressive_disclosure),_ so all but the very most important parameters are completely optional! 😁

<!--## Overview-->
<!---->
<!--<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->-->
<!---->

## Topics

### Essentials
- <doc:Introduction>
<!--- <doc:Quick-Overview>-->
<!--- <doc:Usage>-->

### Presenting alerts (with async/await)
- ``UIKit/UIAlertController/showBasicAlert(_:message:buttonText:actionStyle:actionIcon:preferredAlertStyle:presentingViewController:)``
- ``UIKit/UIAlertController/showOKCancelAlert(_:message:cancelButtonText:cancelActionStyle:cancelActionIcon:okButtonText:okActionStyle:okActionIcon:preferredAction:preferredAlertStyle:presentingViewController:)``
- ``UIKit/UIAlertController/showCustomAlert(_:message:actions:preferredActionIndex:textFieldConfigurationHandler:contentViewController:preferredAlertStyle:presentingViewController:)``


### Presenting alerts (with completion callbacks)

- ``UIKit/UIAlertController/showBasicAlert(_:message:buttonText:actionStyle:actionIcon:preferredAlertStyle:presentingViewController:callback:)``
- ``UIKit/UIAlertController/showOKCancelAlert(_:message:cancelButtonText:cancelActionStyle:cancelActionIcon:okButtonText:okActionStyle:okActionIcon:preferredAction:preferredAlertStyle:presentingViewController:callback:)``
- ``UIKit/UIAlertController/showCustomAlert(_:message:actions:preferredActionIndex:textFieldConfigurationHandler:contentViewController:preferredAlertStyle:presentingViewController:presentionCompletion:)``

### Prompting for values (async/await and completion callbacks)
- ``UIKit/UIAlertController/showPromptForValue(_:message:presetText:placeHolder:keyboardType:cancelButtonText:okButtonText:okActionStyle:okActionIcon:preferredAction:preferredAlertStyle:presentingViewController:)``
- ``UIKit/UIAlertController/showPromptForValue(_:message:presetText:placeHolder:keyboardType:cancelButtonText:okButtonText:okActionStyle:okActionIcon:preferredAction:preferredAlertStyle:presentingViewController:callback:)``
