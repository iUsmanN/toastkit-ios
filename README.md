# ToastKit
A simple lightweight framework to present toasts.

-------

`Liquid` and `Drop` toasts are only supported with Dynamic Island devices on Portrait orientation.

-------
### Toast Types



https://github.com/iUsmanN/toastkit-ios/assets/107039878/9a4ba5e7-31d1-4684-93da-e46b543c99f7



https://github.com/iUsmanN/toastkit-ios/assets/107039878/622bff27-a8e2-4295-abdd-72817d650fa5



https://github.com/iUsmanN/toastkit-ios/assets/107039878/2a6f73d8-1ec9-4238-bb0f-650af7745d02


-------
### Example Usage:

```
struct ExampleView: View {
    var body: some View {
        Button(action: {
            presentToast()
        }, label: {
            Text("Present Toast")
        })
            .onAppear {
                ToastKit.shared.configure(type: .glass)
                print("Configured")
            }
    }
    
    func presentToast() {
        Task {
            await ToastKit.shared.presentToast(message: "Some cool message", color: Color.green)
            print("Presented")
        }
    }
}
```

-------
### Behind the scenes:



https://github.com/iUsmanN/toastkit-ios/assets/107039878/2836a6e5-d7ec-441d-9ef1-f7357986532c



https://github.com/iUsmanN/toastkit-ios/assets/107039878/a00b5e94-2841-4eff-bbdc-cf00bbe06a58



https://github.com/iUsmanN/toastkit-ios/assets/107039878/c8b8deb4-8655-4f10-b5a7-564fa5e0a8f9



https://github.com/iUsmanN/toastkit-ios/assets/107039878/e4d21dc2-5ade-4679-852b-dc8021aaad5e


-------
Usman Nazir
