# GreenAlert ✅

A really useful way to use UIAlertController, using extensions.

Let's say you want to show a basic alert.

Rather than writing this:
```Swift
let alertController = UIAlertController(title: "Title", message: "Message")

let okAction = UIAlertAction(title: "OK", style: .default) { _ in
    ()
}

alertController.addAction(okAction)

present(alertController, animated: true, completion: nil)
```

You can write this:
```Swift
UIAlertController.showBasicAlert("Title", message: "Message")
```

Not a big enough difference for you? Okay, let's suppose you've got a more complicated one.

Instead of THIS:
```Swift
let alertController = UIAlertController(title: "Title", message: "Message")

let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
    // handle Cancel
}

let okAction = UIAlertAction(title: "OK", style: .default) { _ in
    // handle OK
}

alertController.addAction(cancelAction)
alertController.addAction(okAction)

present(alertController, animated: true, completion: nil)
```

Why not have this:
```Swift
UIAlertController.showOKCancelAlert("Title", message: "Message") { confirmed in
    // Handle OK or Cancel based on `confirmed` being true or false
}
```

Now, isn't that nicer?

_But wait, there's more._

With GreenAlert, you're granted all sorts of UIAlertController superpowers, including the following:
- Customizations galore
    - Any alert:
        - SAFELY set alert style to action sheet, using enums to enforce the presence of source information.
            - I say "safely" here because you can easily crash an iPadOS app by creating an actionSheet and forgetting to set the `popoverPresentationController`'s sourceView, sourceRect, or `barButtonItem`. These crashes don't occur on iPhones, and are therefore easy to miss if you don't test throughly. Using GreenAlert eliminates these crashes.
    - OK-Cancel alerts:
        - Custom action icon, via SF Symbols (preferred) or a UIImage
- Show prompts for values
    - With all the customizations listed above, but also including customizable:
        - preset text
        - placeholder
        - keyboard type
- Add progress bars to alert controllers

…And more!
