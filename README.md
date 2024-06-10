# ToastKit

A simple lightweight framework to present toasts in SwiftUI and UIKit.

- Toasts are overlayed on top of the existing view - they are not user interactable.
- Each toast automatically dismisses after 2 seconds.
- A new toast is not presented while the previous one is visible.

-------
As per the latest update,

- `Liquid` toasts are only supported with Dynamic Island devices on Portrait orientation.
- `Drop` toasts are supported with both Notch and Dynamic Island devices.
- Only `Glass` and `Solid` toasts are supported with landscape orientation.

-------
### Toast Types

There are 4 types of Toasts that can be presented: `Liquid`, `Drop`, `Glass` and `Solid`

<img src="https://github.com/iUsmanN/toastkit-ios/assets/107039878/898e5f07-267e-4e4e-9958-01e317928663" width=1000>
<img src="https://github.com/iUsmanN/toastkit-ios/assets/107039878/e0ad7204-571a-42af-8729-2953021d688e" width=1000>

-------
### Example SwiftUI Code:

```
import SwiftUI

struct ExampleView: View {
    var body: some View {
        Button(action: {
            presentToast()
        }, label: {
            Text("Present Toast")
        })
        .onAppear {
            ToastKit.shared.configure(type: .drop)
        }
    }
    
    func presentToast() {
        Task {
            await ToastKit.shared.presentToast(message: "Some cool message",
                                               color: Color.yellow)
        }
    }
}

#Preview {
    ExampleView()
}
```
<!---
-------
### Behind the scenes:



https://github.com/iUsmanN/toastkit-ios/assets/107039878/2836a6e5-d7ec-441d-9ef1-f7357986532c



https://github.com/iUsmanN/toastkit-ios/assets/107039878/a00b5e94-2841-4eff-bbdc-cf00bbe06a58



https://github.com/iUsmanN/toastkit-ios/assets/107039878/c8b8deb4-8655-4f10-b5a7-564fa5e0a8f9



https://github.com/iUsmanN/toastkit-ios/assets/107039878/e4d21dc2-5ade-4679-852b-dc8021aaad5e
--->

-------
Usman Nazir
