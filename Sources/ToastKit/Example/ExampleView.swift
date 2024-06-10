//
//  SwiftUIView.swift
//
//
//  Created by Usman Nazir on 09/06/2024.
//

import SwiftUI

struct ExampleView: View {
    var body: some View {
        Button(action: {
            presentToast()
        }, label: {
            Text("Present Toast")
        })
        Button(action: {
            presentToast2()
        }, label: {
            Text("Present Another Toast")
        })
        .onAppear {
            ToastKit.configure(type: .glass)
        }
    }
    
    func presentToast() {
        Task {
            await ToastKit.present(message: "Some cool message", color: Color.red)
        }
    }
    
    func presentToast2() {
        Task {
            await ToastKit.present(message: "Another cool message", color: Color.green)
        }
    }
}

#Preview {
    ExampleView()
}
